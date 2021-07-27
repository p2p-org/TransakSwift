//
//  WidgetTests.swift
//  TransakSwift_Tests
//
//  Created by Chung Tran on 27/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import TransakSwift

class WidgetTests: XCTestCase {
    func testEnvironmentURL() throws {
        // staging
        let stagingEnv = TransakWidgetViewController.Environment.staging
        XCTAssertEqual(stagingEnv.url, "https://staging-global.transak.com")
        
        // production
        let params = TransakWidgetViewController.Params(
            apiKey: "4fcd6904-706b-4aff-bd9d-77422813bbb7",
            hostURL: "https://yourCompany.com",
            additionalParams: [
                "cryptoCurrencyCode": "ETH",
                "walletAddress": "0x86349020e9394b2BE1b1262531B0C3335fc32F20"
            ]
        )
        let prodEnv = TransakWidgetViewController.Environment.production(params: params)
        XCTAssertEqual(prodEnv.url, "https://global.transak.com?apiKey=4fcd6904-706b-4aff-bd9d-77422813bbb7&cryptoCurrencyCode=ETH&hostURL=https://yourCompany.com&walletAddress=0x86349020e9394b2BE1b1262531B0C3335fc32F20")
    }
}
