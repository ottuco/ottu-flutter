package com.ottu.flutter.checkout

import kotlinx.serialization.Serializable

@Serializable
data class CustomerTheme(
    val uiMode: String?,
    val mainTitleText: TextStyle?,
    val selectPaymentMethodHeaderText: TextStyle?,
    val titleText: TextStyle?,
    val subtitleText: TextStyle?,
    val feesTitleText: TextStyle?,
    val feesSubtitleText: TextStyle?,
    val dataLabelText: TextStyle?,
    val dataValueText: TextStyle?,
    val errorMessageText: TextStyle?,
    val inputTextField: TextFieldStyle?,
    val sdkBackgroundColor: ColorState?,
    val modalBackgroundColor: ColorState?,
    val selectPaymentMethodHeaderBackgroundColor: ColorState?,
    val paymentItemBackgroundColor: ColorState?,
    val selectorIconColor: ColorState?,
    val savePhoneNumberIconColor: ColorState?,
    val button: ButtonComponent?,
    val backButton: RippleColor?,
    val selectorButton: ButtonComponent?,
    val switchControl: SwitchComponent?,
    val margins: Margins?,
)

@Serializable
data class ColorState(
    val color: String?,
    val colorDisabled: String?,
)

@Serializable
data class RippleColor(
    val color: String?,
    val rippleColor: String?,
    val colorDisabled: String?,
)

@Serializable
data class TextStyle(
    val textColor: ColorState?,
    val fontType: Int?,
)

@Serializable
data class TextFieldStyle(
    val background: ColorState?,
    val primaryColor: ColorState?,
    val focusedColor: ColorState?,
    val text: TextStyle?,
    val error: TextStyle?,
)

@Serializable
data class Margins(
    val left: Int = 0,
    val top: Int = 0,
    val right: Int = 0,
    val bottom: Int = 0,
)

@Serializable
data class ButtonComponent(
    val rippleColor: RippleColor? = null,
    val fontType: Int? = null,
    val textColor: ColorState? = null,
)

@Serializable
data class SwitchComponent(
    val checkedThumbTintColor: String? = null,
    val uncheckedThumbTintColor: String? = null,
    val checkedTrackTintColor: String? = null,
    val uncheckedTrackTintColor: String? = null,
    val checkedTrackDecorationColor: String? = null,
    val uncheckedTrackDecorationColor: String? = null,
)