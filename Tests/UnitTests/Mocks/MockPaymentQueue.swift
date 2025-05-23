//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  MockPaymentQueue.swift
//
//  Created by Nacho Soto on 9/30/22.

import StoreKit

final class MockPaymentQueue: SKPaymentQueue {

    var addedPayments: [SKPayment] = []
    override func add(_ payment: SKPayment) {
        addedPayments.append(payment)
    }

    var observers: [SKPaymentTransactionObserver] = []
    override func add(_ observer: SKPaymentTransactionObserver) {
        observers.append(observer)
    }

    override func remove(_ observer: SKPaymentTransactionObserver) {
        let index = observers.firstIndex { $0 === observer }
        observers.remove(at: index!)
    }

    var finishedTransactions: [SKPaymentTransaction] = []
    override func finishTransaction(_ transaction: SKPaymentTransaction) {
        finishedTransactions.append(transaction)
    }

    var stubbedStorefront: SKStorefront?
    override var storefront: SKStorefront? {
        stubbedStorefront ?? super.storefront
    }

#if os(iOS) || targetEnvironment(macCatalyst) || VISION_OS
    @available(iOS 13.4, macCatalyst 13.4, *)
    func simulatePaymentQueueShouldShowPriceConsent() -> [Bool] {
        return self.observers
            .compactMap { $0 as? SKPaymentQueueDelegate }
            .compactMap { $0.paymentQueueShouldShowPriceConsent?(self) }
    }
#endif

}

final class MockSK1Storefront: SKStorefront, @unchecked Sendable {
    private let _countryCode: String

    override var countryCode: String {
        return _countryCode
    }

    override var identifier: String {
        return _countryCode
    }

    init(countryCode: String) {
        self._countryCode = countryCode
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MockPaymentQueue: @unchecked Sendable {}
