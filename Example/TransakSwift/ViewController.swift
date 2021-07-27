//
//  ViewController.swift
//  TransakSwift
//
//  Created by Chung Tran on 07/27/2021.
//  Copyright (c) 2021 Chung Tran. All rights reserved.
//

import UIKit
import BEPureLayout
import TransakSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let stackView = UIStackView(axis: .vertical, spacing: 10, alignment: .center, distribution: .fill) {
            UIButton(label: "Open widgets", labelFont: .boldSystemFont(ofSize: 15), textColor: .systemBlue)
                .onTap(self, action: #selector(openWidgets))
        }
        view.addSubview(stackView)
        stackView.autoCenterInSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func openWidgets() {
        let alert = UIAlertController(title: "Choose environment", message: "Please choose environment", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Production", style: .default) { [weak self] _ in
            self?.openWidget(env: .production(params: .init(
                apiKey: "4fcd6904-706b-4aff-bd9d-77422813bbb7",
                hostURL: "https://yourCompany.com",
                additionalParams: [
                    "cryptoCurrencyCode": "ETH",
                    "walletAddress": "0x86349020e9394b2BE1b1262531B0C3335fc32F20"
                ]
            )))
        })
        alert.addAction(UIAlertAction(title: "Staging", style: .cancel) { [weak self] _ in
            self?.openWidget(env: .staging)
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func openWidget(env: TransakWidgetViewController.Environment) {
        let vc = TransakWidgetViewController(env: env)
        present(vc, animated: true, completion: nil)
    }
}

