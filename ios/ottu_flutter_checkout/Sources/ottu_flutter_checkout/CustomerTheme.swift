//
//  CustomerTheme.swift
//  ottu_flutter_checkout
//
//  Created by Vi on 29.10.2024.
//

struct CustomerTheme: Decodable {
    let uiMode: String?
    let mainTitleText: TextStyle?
    let selectPaymentMethodHeaderText: TextStyle?
    let titleText: TextStyle?
    let subtitleText: TextStyle?
    let feesTitleText: TextStyle?
    let feesSubtitleText: TextStyle?
    let dataLabelText: TextStyle?
    let dataValueText: TextStyle?
    let errorMessageText: TextStyle?
    let inputTextField: TextFieldStyle?
    let sdkBackgroundColor: ColorState?
    let modalBackgroundColor: ColorState?
    let selectPaymentMethodHeaderBackgroundColor: ColorState?
    let paymentItemBackgroundColor: ColorState?
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
    let fontType: Int?
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
    let fontType: Int?
    let textColor: ColorState?
    let textDisabledColor: ColorState?
}

struct SwitchComponent: Decodable {
    let checkedThumbTintColor: String?
    let uncheckedThumbTintColor: String?
    let checkedTrackTintColor: String?
    let uncheckedTrackTintColor: String?
    let checkedTrackDecorationColor: String?
    let uncheckedTrackDecorationColor: String?
}
