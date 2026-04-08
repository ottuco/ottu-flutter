package com.ottu.flutter.checkout.ext

import android.content.res.Resources
import android.graphics.Color
import android.util.Log
import com.ottu.checkout.ui.theme.CheckoutTheme
import com.ottu.flutter.checkout.ButtonComponent
import com.ottu.flutter.checkout.ColorState
import com.ottu.flutter.checkout.Margins
import com.ottu.flutter.checkout.PayButtonText
import com.ottu.flutter.checkout.RippleColor
import com.ottu.flutter.checkout.SwitchComponent
import com.ottu.flutter.checkout.TextFieldStyle
import com.ottu.flutter.checkout.TextStyle
import com.ottu.checkout.data.model.localization.PayButtonText as pbt
import com.ottu.checkout.ui.theme.style.Margins as CheckoutMargins

fun String.toColor() = this.let {
    try {
        Color.parseColor(it)
    } catch (e: Exception) {
        Log.w("Extensions", "toColor", e)
    }
}

fun ColorState.toCheckoutColor() = CheckoutTheme.Color(
    color = this.color?.toColor(),
    colorDisabled = colorDisabled?.toColor()
)

fun TextStyle.toCheckoutText(resources: Resources, packageName: String): CheckoutTheme.Text {
    val fontResId = this.fontFamily?.findFontResId(resources = resources, packageName = packageName)

    return CheckoutTheme.Text(
        textColor = this.textColor?.toCheckoutColor(),
        fontType = fontResId
    )
}

fun TextFieldStyle.toCheckoutTextField(resources: Resources, packageName: String) =
    CheckoutTheme.TextField(
        background = this.background?.toCheckoutColor(),
        primaryColor = this.primaryColor?.toCheckoutColor(),
        focusedColor = this.focusedColor?.toCheckoutColor(),
        text = this.text?.toCheckoutText(resources = resources, packageName = packageName),
        error = this.error?.toCheckoutText(resources = resources, packageName = packageName)
    )

fun Margins.toMargins() = CheckoutMargins(
    left = this.left,
    top = this.top,
    right = right,
    bottom = this.bottom,
)

fun ButtonComponent.toCheckoutButton(
    resources: Resources,
    packageName: String,
): CheckoutTheme.Button {
    val fontResId = this.fontFamily?.findFontResId(resources = resources, packageName = packageName)
    return CheckoutTheme.Button(
        textColor = this.textColor?.toCheckoutColor(),
        rippleColor = this.rippleColor?.toCheckoutRipple(),
        fontType = fontResId,
        borderColor = this.borderColor?.toCheckoutColor(),
        borderWidth = this.borderWidth,
        cornerRadius = this.cornerRadius,
    )
}

fun RippleColor.toCheckoutRipple() = CheckoutTheme.RippleColor(
    color = this.color?.toColor(),
    rippleColor = this.rippleColor?.toColor(),
    colorDisabled = this.colorDisabled?.toColor()
)

fun SwitchComponent.toCheckoutSwitch() = CheckoutTheme.Switch(
    checkedThumbTintColor = this.checkedThumbTintColor?.toColor(),
    uncheckedThumbTintColor = this.uncheckedThumbTintColor?.toColor(),
    checkedTrackTintColor = this.checkedTrackTintColor?.toColor(),
    uncheckedTrackTintColor = this.uncheckedTrackTintColor?.toColor(),
    checkedTrackDecorationColor = this.checkedTrackDecorationColor?.toColor(),
    uncheckedTrackDecorationColor = this.uncheckedTrackDecorationColor?.toColor()
)

fun PayButtonText.toPayButtonText() = pbt(en = en, ar = ar)

fun String.findFontResId(resources: Resources, packageName: String) = try {
    val sanitized = this.lowercase().replace(" ", "_")
    Log.d("Extensions", "findFontResId, with name: $sanitized")
    resources.getIdentifier(sanitized, "font", packageName).let { if (it == 0) null else it }
} catch (e: Exception) {
    Log.e("Extensions", "findFontResId", e)
    null
}