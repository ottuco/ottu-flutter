import Flutter
import Foundation
import SwiftUI
import ottu_checkout_sdk

//
//  CheckoutPlatformView.swift
//  Runner
//
//  Created by Vi on 25.09.2024.
//

private let checkoutChannelName = "com.ottu.sample/checkout"
private let methodCheckoutHeight = "METHOD_CHECKOUT_HEIGHT"
private let _methodPaymentSuccessResult = "METHOD_PAYMENT_SUCCESS_RESULT"
private let _methodPaymentErrorResult = "METHOD_PAYMENT_ERROR_RESULT"
private let _methodPaymentCancelResult = "METHOD_PAYMENT_CANCEL_RESULT"
private let _methodOnWidgetDetached = "METHOD_ON_WIDGET_DETACHED"

public class CheckoutPlatformView: NSObject, FlutterPlatformView {
    private let viewId: Int64
    private let channel: FlutterMethodChannel
    private let _view: CheckoutContainerView
    private weak var paymentViewController: UIViewController?
    private var checkout: Checkout?
    
    private func deinitCheckout() {
        guard let pvc = paymentViewController,
              let parentVC = UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController
        else { return }
        
        if parentVC.children.contains(pvc) {
            pvc.willMove(toParent: nil)
            pvc.view.removeFromSuperview()
            pvc.removeFromParent()
            print("Removed from parent!")
        } else {
            print("No parent relationship found, nothing to remove.")
        }
    }
    
    @MainActor
    init(
        messenger: FlutterBinaryMessenger,
        frame: CGRect,
        viewId: Int64,
        args: Any?
    ) {
        
        self.viewId = viewId
        self.channel = FlutterMethodChannel(
            name: checkoutChannelName,
            binaryMessenger: messenger
        )
        _view = CheckoutContainerView()
        super.init()
        
        self.channel.setMethodCallHandler { [weak self] call, _ in
            guard let self else { return }
            if call.method == _methodOnWidgetDetached {
                self.deinitCheckout()
            }
        }
        let jsonData: Data? =
        if args != nil {
            if let dictionaryArgs = args as? [String: Any] {
                (dictionaryArgs["args"] as? String)?.data(using: .utf8)
            } else {
                nil
            }
        } else { nil }
        
        if jsonData != nil {
            do {
                let arguments: CheckoutArguments? = try? JSONDecoder().decode(
                    CheckoutArguments.self,
                    from: jsonData!
                )
                
                self._view.onHeightChanged = { [weak self] (height: Int) in
                    guard let self else { return }
                    debugPrint(
                        "CheckoutPlatformView, onHeightChanged: \(height)")
                    self.channel.invokeMethod(
                        methodCheckoutHeight, arguments: height)
                }
                
                if arguments != nil {
                    createNativeView(arguments: arguments!)
                }
            } catch {
                debugPrint("Unexpected error: \(error).")
            }
        }
    }
    
    public func view() -> UIView {
        return _view
    }
    
    fileprivate func showSdkError() {
        if let parentVC = UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController {
            let title = NSLocalizedString("failed", bundle: Bundle.module, comment: "title of the dialog")
            let message = NSLocalizedString("failed_start_payment", bundle: Bundle.module, comment: "messafe of the dialog")
            let ok = NSLocalizedString("ok", bundle: Bundle.module, comment: "button label")
            
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: ok, style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                }
            }))
            parentVC.present(alert, animated: true, completion: nil)
        }
    }
    
    @MainActor
    func createNativeView(arguments: CheckoutArguments) {
        debugPrint("createNativeView")
        let theme = getCheckoutTheme(
            arguments.theme, showPaymentDetails: arguments.showPaymentDetails)
        let formsOfPayment =
        arguments.formsOfPayment?.map(
            { code in FormOfPayment(rawValue: code)
            }).compactMap { $0 } ?? []
        
        debugPrint("formsOfPayment")
        
        let paymentOptionsDisplaySettings:ottu_checkout_sdk.PaymentOptionsDisplaySettings =
        if arguments.paymentOptionsDisplaySettings.mode == "list" {
            ottu_checkout_sdk.PaymentOptionsDisplaySettings(
                mode: .list,
                visibleItemsCount:UInt(arguments.paymentOptionsDisplaySettings.visibleItemsCount),
                defaultSelectedPgCode:arguments.paymentOptionsDisplaySettings.defaultSelectedPgCode,
            )
        } else {
            ottu_checkout_sdk.PaymentOptionsDisplaySettings(
                mode: .bottomSheet,
                defaultSelectedPgCode: arguments.paymentOptionsDisplaySettings.defaultSelectedPgCode,
            )
        }
        
        
        var apiTransactionDetails: TransactionDetailsResponse?
        if let transactionDetails: String? = arguments.apiTransactionDetails {
            if let td = transactionDetails {
                apiTransactionDetails = try! getApiTransactionDetails(td)
            }
        }
        do {
            let transactionDetails: TransactionDetails? = try
            apiTransactionDetails?.transactionDetails
            debugPrint("setupPreload")
            self.checkout = try Checkout(
                formsOfPayments: formsOfPayment,
                theme: theme,
                displaySettings:paymentOptionsDisplaySettings,
                sessionId: arguments.sessionId,
                merchantId: arguments.merchantId,
                apiKey: arguments.apiKey,
                setupPreload: transactionDetails,
                
                delegate: self
            )
            if let cht = checkout {
                self.paymentViewController = cht.paymentViewController()
                tryAttachController()
            }
        } catch {
            debugPrint(error)
            showSdkError()
        }
    }
    
    func tryAttachController() {
        guard let pvc = self.paymentViewController else { return }
        
        if let parentVC = UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController {
            parentVC.addChild(pvc)
            _view.addCheckoutView(pvc.view)
            pvc.didMove(toParent: parentVC)
            print("Added to parent!")
        } else {
            print("Waiting for parent...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.tryAttachController()
            }
        }
    }
    
    private func getApiTransactionDetails(_ transactionDetails: String) throws
    -> TransactionDetailsResponse?
    {
        if let jsonData = transactionDetails.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(
                    TransactionDetailsResponse.self, from: jsonData)
            } catch let DecodingError.keyNotFound(key, context) {
                debugPrint(
                    "Decoding error (keyNotFound): \(key) not found in \(context.debugDescription)"
                )
                debugPrint("Coding path: \(context.codingPath)")
            } catch let DecodingError.dataCorrupted(context) {
                debugPrint(
                    "Decoding error (dataCorrupted): data corrupted in \(context.debugDescription)"
                )
                debugPrint("Coding path: \(context.codingPath)")
            } catch let DecodingError.typeMismatch(type, context) {
                debugPrint(
                    "Decoding error (typeMismatch): type mismatch of \(type) in \(context.debugDescription)"
                )
                debugPrint("Coding path: \(context.codingPath)")
            } catch let DecodingError.valueNotFound(type, context) {
                debugPrint(
                    "Decoding error (valueNotFound): value not found for \(type) in \(context.debugDescription)"
                )
                debugPrint("Coding path: \(context.codingPath)")
            }
            
            return nil
        }
        
        return nil
    }
    
    private func getCheckoutTheme(_ theme: CustomerTheme?, showPaymentDetails: Bool) -> CheckoutTheme {
        let cht = CheckoutTheme()
        cht.showPaymentDetails = showPaymentDetails
        
        if theme == nil {
            return cht
        }
        
        if let color = theme?.sdkBackgroundColor?.toUIColors() {
            if let cc = color.color {
                cht.backgroundColor = cc
            }
        }
        
        if let color = theme?.modalBackgroundColor?.toUIColors() {
            if let cc = color.color {
                cht.backgroundColorModal = cc
            }
        }
        
        if let color = theme?.selectPaymentMethodHeaderBackgroundColor?.toUIColors() {
            if let cc = color.color {
                cht.selectPaymentMethodTitleBackgroundColor = cc
            }
        }
        
        if let comp = theme?.mainTitleText?.toLabelComponent(ofSize: 20, weight: .semibold) {
            cht.mainTitle = comp
        }
        
        if let comp = theme?.selectPaymentMethodHeaderText?.toLabelComponent(ofSize: 20, weight: .semibold) {
            cht.selectPaymentMethodTitleLabel = comp
        }
        
        if let comp = theme?.titleText?.toLabelComponent(ofSize: 17, weight: .semibold) {
            cht.title = comp
        }
        
        if let comp = theme?.subtitleText?.toLabelComponent(ofSize: 15) {
            cht.subtitle = comp
        }
        
        if let comp = theme?.feesTitleText?.toLabelComponent(ofSize: 17) {
            cht.feesTitle = comp
        }
        
        if let comp = theme?.feesSubtitleText?.toLabelComponent(ofSize: 15) {
            cht.feesSubtitle = comp
        }
        
        if let comp = theme?.dataLabelText?.toLabelComponent(ofSize: 14, weight: .semibold) {
            cht.dataLabel = comp
        }
        
        if let comp = theme?.dataValueText?.toLabelComponent(ofSize: 16, weight: .semibold) {
            cht.dataValue = comp
        }
        
        if let comp = theme?.errorMessageText?.toLabelComponent(ofSize: 13, weight: .semibold) {
            cht.errorMessage = comp
        }
        
        if let color = theme?.savePhoneNumberIconColor?.toUIColors() {
            if let cc = color.color {
                //cht.savePhoneNumberIconColor = cc
            }
        }
        
        if let color = theme?.selectorIconColor?.toUIColors() {
            if let cc = color.color {
                //cht.selectorIconColor = cc
            }
        }
        
        if let color = theme?.paymentItemBackgroundColor?.toUIColors() {
            if let cc = color.color {
                cht.paymentItemBackgroundColor = cc
            }
        }
        
        if let switchColor = theme?.switchControl?.toCheckoutSwitch() {
            cht.switchOnTintColor = switchColor
        }
        
        if let button = theme?.button?.toCheckoutButton() {
            cht.button = button
        }
        
        if let selectorButton = theme?.selectorButton?.toCheckoutButton() {
            cht.selectorButton = selectorButton
        }
        
        if let iMargins = theme?.margins?.toMargins() {
            cht.margins = iMargins
        }
        
        if let iconColor = theme?.selectorIconColor?.toUIColors() {
            if let cc = iconColor.color {
                cht.iconColor = cc
            }
        }
        
        return cht
    }
}

extension CheckoutPlatformView: OttuDelegate {
    public func errorCallback(_ data: [String: Any]?) {
        debugPrint("errorCallback\n")
        DispatchQueue.main
            .async {
                if let message = data?.description {
                    self.channel.invokeMethod(_methodPaymentErrorResult, arguments: message)
                }
                
                self.paymentViewController?.view.isHidden = true
                self.paymentViewController?.view.setNeedsLayout()
                self.paymentViewController?.view.layoutIfNeeded()
                self._view.heightHandlerView.setNeedsLayout()
                self._view.heightHandlerView.layoutIfNeeded()
                self._view.setNeedsLayout()
                self._view.layoutIfNeeded()
            }
    }
    
    public func cancelCallback(_ data: [String: Any]?) {
        debugPrint("cancelCallback\n")
        DispatchQueue.main
            .async {
                if let message = data?.description {
                    self.channel.invokeMethod(_methodPaymentCancelResult, arguments: message)
                }
                
                self.paymentViewController?.view.setNeedsLayout()
                self.paymentViewController?.view.layoutIfNeeded()
                self._view.heightHandlerView.setNeedsLayout()
                self._view.heightHandlerView.layoutIfNeeded()
                self._view.setNeedsLayout()
                self._view.layoutIfNeeded()
            }
    }
    
    public func successCallback(_ data: [String: Any]?) {
        debugPrint("successCallback\n")
        DispatchQueue.main.async {
            if let message = data?.description {
                self.channel.invokeMethod(_methodPaymentSuccessResult, arguments: message)
            }
            
            //self.paymentViewController?.view.isHidden = true
            self.paymentViewController?.view.setNeedsLayout()
            self.paymentViewController?.view.layoutIfNeeded()
            self._view.heightHandlerView.setNeedsLayout()
            self._view.heightHandlerView.layoutIfNeeded()
            self._view.setNeedsLayout()
            self._view.layoutIfNeeded()
        }
    }
}

private class CheckoutContainerView: UIView {
    let heightHandlerView: CheckoutHeightHandlerView
    
    override init(frame: CGRect) {
        
        heightHandlerView = CheckoutHeightHandlerView()
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var onHeightChanged: ((Int) -> Void)?
    
    func addCheckoutView(_ checkoutView: UIView) {
        self.heightHandlerView.onHeightChanged = self.onHeightChanged
        self.heightHandlerView.translatesAutoresizingMaskIntoConstraints = false
        checkoutView.translatesAutoresizingMaskIntoConstraints = false
        checkoutView.accessibilityIdentifier = "CheckoutView"
        
        addSubview(heightHandlerView)
        addSubview(checkoutView)
        heightHandlerView.addSubview(checkoutView)
        
        NSLayoutConstraint.activate([
            heightHandlerView.leftAnchor.constraint(
                equalTo: self.leftAnchor),
            heightHandlerView.rightAnchor.constraint(
                equalTo: self.rightAnchor),
            heightHandlerView.topAnchor.constraint(equalTo: self.topAnchor),
            //checkoutHeightHandler.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            checkoutView.leftAnchor.constraint(
                equalTo: heightHandlerView.leftAnchor),
            checkoutView.rightAnchor.constraint(
                equalTo: heightHandlerView.rightAnchor),
            checkoutView.topAnchor.constraint(
                equalTo: heightHandlerView.topAnchor),
            checkoutView.bottomAnchor.constraint(
                equalTo: heightHandlerView.bottomAnchor),
        ])
    }
}

private class CheckoutHeightHandlerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var onHeightChanged: ((Int) -> Void)?
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
        debugPrint("--------------------------\n")
        debugPrint("layoutSubviews, parent")
        self.subviews.forEach {
            let subview = $0
            debugPrint("layoutSubviews, child")
            if(subview.accessibilityIdentifier == "CheckoutView" ) {
                if(subview.isHidden == false){
                    NSLayoutConstraint.activate([
                        subview.leftAnchor.constraint(
                            equalTo: self.leftAnchor),
                        subview.rightAnchor.constraint(
                            equalTo: self.rightAnchor),
                        subview.topAnchor.constraint(
                            equalTo: self.topAnchor),
                        subview.bottomAnchor.constraint(
                            equalTo: self.bottomAnchor),
                    ])
                } else {
                    subview.constraints.forEach { const in
                        const.isActive = false
                        debugPrint("layoutSubviews, child constraint: \(const.description)\n\(const.isActive)")
                    }
                }
            }
            debugPrint("\n")
        }
        
        debugPrint("layoutSubviews, bounds")
        onHeightChanged?(
            Int(self.bounds.height)
        )
    }
}
