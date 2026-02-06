//
//  PaymentOptionsDisplaySettings.swift
//  ottu-flutter-checkout
//
//  Created by Vi on 03.11.2025.
//

struct PaymentOptionsDisplaySettings:Decodable {
    let mode: String
    let defaultSelectedPgCode: String?
    let visibleItemsCount: Int
}
