# TransakSwift

[![CI Status](https://img.shields.io/travis/p2p-org/TransakSwift.svg?style=flat)](https://travis-ci.org/p2p-org/TransakSwift)
[![Version](https://img.shields.io/cocoapods/v/TransakSwift.svg?style=flat)](https://cocoapods.org/pods/TransakSwift)
[![License](https://img.shields.io/cocoapods/l/TransakSwift.svg?style=flat)](https://cocoapods.org/pods/TransakSwift)
[![Platform](https://img.shields.io/cocoapods/p/TransakSwift.svg?style=flat)](https://cocoapods.org/pods/TransakSwift)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TransakSwift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TransakSwift'
```

## Usage

The are 2 ways to implement `transak`:
### 1. Implement `transak` as a `Widget` (a `UIViewController`), with `TransakWidgetViewController`

```swift
#if DEBUG
let vc = TransakWidgetViewController(env: .stagging)
present(vc, animated: true, completion: nil)
#else
let vc = TransakWidgetViewController(env: .production(params: .init(
    apiKey: "<YOUR_API_KEY_HERE>",
    hostURL: "<YOUR_COMPANY_URL>",
    additionalParams: [
        "cryptoCurrencyCode": "ETH",
        "walletAddress": "0x86349020e9394b2BE1b1262531B0C3335fc32F20"
        ]
)))
present(vc, animated: true, completion: nil)
#endif
```

### 2. Custom implemetations using Transak API (developing)

## Author

Chung Tran, bigearsenal@gmail.com

## License

TransakSwift is available under the MIT license. See the LICENSE file for more info.
