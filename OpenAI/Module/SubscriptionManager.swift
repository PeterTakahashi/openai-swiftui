//
//  SubscriptionManager.swift
//  OpenAI
//
//  Created by Apple on 2023/04/07.
//

import SwiftUI
import StoreKit

class SubscriptionManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @Published var premiumSubscription: SKProduct?
    @Published var isPurchased = false
    private let productID = "your_product_id"
    
    func fetchSubscription() {
        let request = SKProductsRequest(productIdentifiers: Set([productID]))
        request.delegate = self
        request.start()
    }
    
    func purchaseSubscription() {
        guard let product = premiumSubscription else { return }
        
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            DispatchQueue.main.async {
                self.premiumSubscription = product
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                isPurchased = true
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed, .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
}
