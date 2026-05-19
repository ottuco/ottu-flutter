//
//  CustomerTheme.swift
//  ottu_flutter_checkout
//
//  Created by Vi on 29.10.2024.
//

struct CustomerTheme: Decodable {
    let uiMode: String?
    let mainTitle: TextStyle?
    let selectPaymentMethodHeader: TextStyle?
    let title: TextStyle?
    let subtitle: TextStyle?
    let feesTitle: TextStyle?
    let feesSubtitle: TextStyle?
    let dataLabel: TextStyle?
    let dataValue: TextStyle?
    let errorMessage: TextStyle?
    let inputTextField: TextFieldStyle?
    let backgroundColor: ColorState?
    let modalBackgroundColor: ColorState?
    let selectPaymentItemTitleBackgroundColor: ColorState?
    let paymentItemBackgroundColor: ColorState?
    let paymentItemDescriptionTextColor: ColorState?
    let paymentItemBorderColor: ColorState?
    let paymentItemBorderWidth: Float?
    let paymentItemCornerRadius: Float?
    let selectorIconColor: ColorState?
    let savePhoneNumberIconColor: ColorState?
    let button: ButtonCmt?
    let backButton: RippleColor?
    let selectorButton: ButtonCmt?
    let switchControl: SwitchComponent?
    let margins: Margins?
}

struct ColorState: Decodable {
    let color: String?
    let colorDisabled: String?
}

struct RippleColor: Decodable {
    let color: String?
    let rippleColor: String?
    let colorDisabled: String?
}

struct TextStyle: Decodable {
    let textColor: ColorState?
    let fontFamily: String?
    let fontSize: Int?
}

struct TextFieldStyle: Decodable {
    let background: ColorState?
    let primaryColor: ColorState?
    let focusedColor: ColorState?
    let text: TextStyle?
    let error: TextStyle?
}

struct Margins: Decodable {
    var left: Int = 0
    var top: Int = 0
    var right: Int = 0
    var bottom: Int = 0
}

struct ButtonCmt: Decodable {
    let rippleColor: RippleColor?
    let fontFamily: String?
    let textColor: ColorState?
    let textDisabledColor: ColorState?
    let borderColor: ColorState?
    let borderWidth: Float?
    let cornerRadius: Float?
}

struct SwitchComponent: Decodable {
    let checkedThumbTintColor: String?
    let uncheckedThumbTintColor: String?
    let checkedTrackTintColor: String?
    let uncheckedTrackTintColor: String?
    let checkedTrackDecorationColor: String?
    let uncheckedTrackDecorationColor: String?
}
