//
//  CheckoutArguments.swift
//  ottu-flutter-checkout
//
//  Created by Vi on 10.10.2024.
//

struct CheckoutArguments: Decodable {
    let merchantId: String
    let apiKey: String
    let sessionId: String
    let amount: Double
    let showPaymentDetails: Bool
    let paymentOptionsDisplaySettings: PaymentOptionsDisplaySettings
    let apiTransactionDetails: String?
    let formsOfPayment: [String]?
    let theme: CustomerTheme?
}
