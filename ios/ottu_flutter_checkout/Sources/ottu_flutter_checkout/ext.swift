//
//  ext.swift
//  ottu_flutter_checkout
//
//  Created by Vi on 29.10.2024.
//
import Foundation
import SwiftUI
import UIKit
import ottu_checkout_sdk

extension ColorState {
    public func toUIColors() -> (color: UIColor?, disabledColor: UIColor?) {
        let ucNormal: UIColor? =
        if self.color != nil {
            UIColor(hexString: self.color!)
        } else { nil }
        
        let ucDisabled: UIColor? =
        if self.colorDisabled != nil {
            UIColor(hexString: self.colorDisabled!)
        } else { nil }
        
        return (ucNormal, ucDisabled)
    }
}

extension String {
    public func toUIColor() -> UIColor? {
        let ucNormal: UIColor? =
        if self != nil {
            UIColor(hexString: self)
        } else { nil }
        return ucNormal
    }
}

extension TextStyle {
    public func toLabelComponent(ofSize fontSize: CGFloat, weight: UIFont.Weight? = nil) -> LabelComponent? {
        let labelComponent = LabelComponent()
        if let color = self.textColor?.toUIColors() {
            if let cc = color.color {
                labelComponent.color = cc
            }
        }
        
        var size:CGFloat = fontSize
        if let fs = self.fontSize {
            size = CGFloat(integerLiteral: fs)
        }
        
        if let ff = self.fontFamily {
        if let customFont = UIFont(name: ff, size: size) {
            labelComponent.font = customFont
            } else {
                if let fw = weight {
                    labelComponent.font = .systemFont(ofSize: size, weight: fw)
                } else {
                    labelComponent.font = .systemFont(ofSize: size)
                }
            }
        } else {
            if let fw = weight {
                labelComponent.font = .systemFont(ofSize: size, weight: fw)
            } else {
                labelComponent.font = .systemFont(ofSize: size)
            }
        }
        
        return labelComponent
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3:  // RGB (12-bit)
            (a, r, g, b) = (
                255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17
            )
        case 6:  // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  // ARGB (32-bit)
            (a, r, g, b) = (
                int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF
            )
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255, green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(
//            in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a: UInt64
//        let r: UInt64
//        let g: UInt64
//        let b: UInt64
//        switch hex.count {
//        case 3:  // RGB (12-bit)
//            (a, r, g, b) = (
//                255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17
//            )
//        case 6:  // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8:  // ARGB (32-bit)
//            (a, r, g, b) = (
//                int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF
//            )
//        default:
//            (a, r, g, b) = (1, 1, 1, 0)
//        }
//
//        self.init(
//            .sRGB,
//            red: Double(r) / 255,
//            green: Double(g) / 255,
//            blue: Double(b) / 255,
//            opacity: Double(a) / 255
//        )
//    }
//}

extension TextFieldStyle {
    public func toCheckoutTextField() -> TextFieldComponent {
        let tfc = TextFieldComponent()
        let label = LabelComponent()
        let text = LabelComponent()
        
        let textStyleColor = self.text?.textColor
        
        if let textColors = textStyleColor?.toUIColors() {
            if let color = textColors.color {
                label.color = color
                text.color = color
            }
        }
        
        //primaryColor = this.primaryColor?.toCheckoutColor(),
        //focusedColor = this.focusedColor?.toCheckoutColor(),
        //text = this.text?.toCheckoutText(),
        //error = this.error?.toCheckoutText()
        
        tfc.label = label
        tfc.text = text
        
        return tfc
    }
}

extension Margins {
    public func toMargins() -> UIEdgeInsets {
        return UIEdgeInsets(
            top: CGFloat(self.top),
            left: CGFloat(self.left),
            bottom: CGFloat(self.bottom),
            right: CGFloat(self.right)
        )
    }
}

extension ButtonCmt {
    public func toCheckoutButton() -> ButtonComponent {
        let bc = ButtonComponent()
        
        let textColors = self.textColor?.toUIColors()
        let buttonColor = self.rippleColor?.color?.toUIColor()
        let buttonDisabledColor = self.rippleColor?.colorDisabled?.toUIColor()
        let fontType = self.fontType
        
        if let btnC = buttonColor {
            bc.enabledBackgroundColor = btnC
        }
        
        if let btnDC = buttonDisabledColor {
            bc.disabledBackgroundColor = btnDC
        }
        
        if let textColorNormal = textColors?.color {
            bc.enabledTitleColor = textColorNormal
        }
        if let textColorDisabled = textColors?.disabledColor {
            bc.disabledTitleColor = textColorDisabled
        }
        
        return bc
    }
}

extension SwitchComponent {
    public func toCheckoutSwitch() -> UIColor? {
        
        return if self.checkedThumbTintColor != nil {
            UIColor(hexString: self.checkedThumbTintColor!)
        } else { nil }
        
        //        CheckoutTheme.Switch(
        //    checkedThumbTintColor = this.checkedThumbTintColor?.toColor(),
        //    uncheckedThumbTintColor = this.uncheckedThumbTintColor?.toColor(),
        //    checkedTrackTintColor = this.checkedTrackTintColor?.toColor(),
        //    uncheckedTrackTintColor = this.uncheckedTrackTintColor?.toColor(),
        //    checkedTrackDecorationColor = this.checkedTrackDecorationColor?.toColor(),
        //    uncheckedTrackDecorationColor = this.uncheckedTrackDecorationColor?.toColor()
        //
        //
        //
    }
}
