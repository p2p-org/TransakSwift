//
//  TransakViewController.swift
//  FBSnapshotTestCase
//
//  Created by Chung Tran on 27/07/2021.
//

import WebKit

public protocol LoadingView: UIView {
    func startLoading()
    func stopLoading()
}

extension UIActivityIndicatorView: LoadingView {
    public func startLoading() {
        startAnimating()
    }
    public func stopLoading() {
        stopAnimating()
    }
}

open class TransakWidgetViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    // MARK: - Nested type
    public struct Params {
        public init(apiKey: String, hostURL: String, additionalParams: [String : String] = [:]) {
            self.apiKey = apiKey
            self.hostURL = hostURL
            self.additionalParams = additionalParams
        }
        
        let apiKey: String          // required
        let hostURL: String         // required
        let additionalParams: [String: String]
        
        var dict: [String: String] {
            [
                "apiKey": apiKey,
                "hostURL": hostURL
            ]
            .merging(additionalParams) { current, _ in current }
        }
        
        var query: String {
            dict.keys.sorted().map {"\($0)=\(dict[$0]!)"}.joined(separator: "&")
        }
    }
    
    public enum Environment {
        case staging
        case production(params: Params)
        
        var query: String? {
            switch self {
            case .staging:
                return nil
            case .production(let params):
                return params.query
            }
        }
        
        var endpoint: String {
            switch self {
            case .staging:
                return "https://staging-global.transak.com"
            case .production:
                return "https://global.transak.com"
            }
        }
        
        var url: String {
            var urlString = endpoint
            if let query = query {
                urlString += ("?" + query)
            }
            return urlString
        }
    }
    
    // MARK: - Properties
    let env: Environment
    var loadsCount = 0
    
    // MARK: - Initializers
    public init(env: Environment, loadingView: LoadingView = UIActivityIndicatorView()) {
        self.env = env
        self.loadingView = loadingView
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let loadingView: LoadingView
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        
        // add loader
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        guard let myURL = URL(string: env.url) else {
            let alert = UIAlertController(title: "Invalid URL", message: "The url isn't valid \(env.url)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        startLoading()
        
        // load url
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        }
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadsCount += 1
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadsCount -= 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            if self?.loadsCount == 0 {
                self?.stopLoading()
            }
        }
    }
    
    // MARK: - Loading view
    private func startLoading() {
        loadingView.isHidden = false
        loadingView.startLoading()
    }
    
    private func stopLoading() {
        loadingView.isHidden = true
        loadingView.stopLoading()
    }
}
