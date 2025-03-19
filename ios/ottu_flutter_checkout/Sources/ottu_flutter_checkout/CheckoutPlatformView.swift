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

public class CheckoutPlatformView: NSObject, FlutterPlatformView {
    private let viewId: Int64
    private let channel: FlutterMethodChannel
    private let _view: CheckoutContainerView
    private var paymentViewController: UIViewController?
    
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
        debugPrint("createNativeView, args: \(args)")
        
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
                
                self._view.onHeightChanged = { (height: Int) in
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
    
    @MainActor
    func createNativeView(arguments: CheckoutArguments) {
        debugPrint("createNativeView, checkout args: \(arguments)")
        let theme = getCheckoutTheme(
            arguments.theme, showPaymentDetails: arguments.showPaymentDetails)
        let formsOfPayment =
        arguments.formsOfPayment?.map(
            { code in FormOfPayment.of(code)
            }).compactMap { $0 } ?? []
        
        debugPrint("formsOfPayment: \(formsOfPayment)")
        
        var apiTransactionDetails: RemoteTransactionDetails?
        if let transactionDetails: String? = arguments.apiTransactionDetails {
            if let td = transactionDetails {
                apiTransactionDetails = try! getApiTransactionDetails(td)
            }
        }
        do {
            let transactionDetails: TransactionDetails? = try
            apiTransactionDetails?.transactionDetails
            debugPrint("setupPreload: \(transactionDetails)")
            let checkout = Checkout(
                formsOfPayments: formsOfPayment,
                theme: theme,
                sessionId: arguments.sessionId,
                merchantId: arguments.merchantId,
                apiKey: arguments.apiKey,
                setupPreload: transactionDetails,
                delegate: self
            )
            self.paymentViewController = checkout.paymentViewController()
            
            if let pvc = self.paymentViewController {
                _view.addCheckoutView(pvc.view)
            }
        } catch {
            debugPrint(error)
        }
    }
    
    private func getApiTransactionDetails(_ transactionDetails: String) throws
    -> RemoteTransactionDetails?
    {
        if let jsonData = transactionDetails.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(
                    RemoteTransactionDetails.self, from: jsonData)
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
        
        if let comp = theme?.mainTitleText?.toLabelComponent() {
            cht.mainTitle = comp
        }
        if let comp = theme?.titleText?.toLabelComponent() {
            cht.title = comp
        }
        
        if let comp = theme?.subtitleText?.toLabelComponent() {
            cht.subtitle = comp
        }
        if let comp = theme?.feesTitleText?.toLabelComponent() {
            cht.feesTitle = comp
        }
        if let comp = theme?.feesSubtitleText?.toLabelComponent() {
            cht.feesSubtitle = comp
        }
        
        if let comp = theme?.dataLabelText?.toLabelComponent() {
            cht.dataLabel = comp
        }
        if let comp = theme?.dataValueText?.toLabelComponent() {
            cht.dataValue = comp
        }
        if let comp = theme?.errorMessageText?.toLabelComponent() {
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
                //cht.paymentItemBackgroundColor = cc
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
                self.paymentViewController?.view.isHidden = true
                self.paymentViewController?.view.setNeedsLayout()
                self.paymentViewController?.view.layoutIfNeeded()
                self._view.heightHandlerView.setNeedsLayout()
                self._view.heightHandlerView.layoutIfNeeded()
                self._view.setNeedsLayout()
                self._view.layoutIfNeeded()
                
                let alert = UIAlertController(
                    title: "Error",
                    message: data?.debugDescription ?? "",
                    preferredStyle: .alert
                )
                alert
                    .addAction(
                        UIAlertAction(
                            title: "OK",
                            style: .cancel
                        )
                    )
                debugPrint("errorCallback, show alert\n")
                self.paymentViewController?.present(alert, animated: true)
            }
    }
    
    public func cancelCallback(_ data: [String: Any]?) {
        debugPrint("cancelCallback\n")
        DispatchQueue.main
            .async {
                var message = ""
                
                if let paymentGatewayInfo = data?["payment_gateway_info"]
                    as? [String: Any],
                   let pgName = paymentGatewayInfo["pg_name"] as? String,
                   pgName == "kpay"
                {
                    message = paymentGatewayInfo["pg_response"].debugDescription
                } else {
                    message = data?.debugDescription ?? ""
                }
                
                self.paymentViewController?.view.isHidden = true
                self.paymentViewController?.view.setNeedsLayout()
                self.paymentViewController?.view.layoutIfNeeded()
                self._view.heightHandlerView.setNeedsLayout()
                self._view.heightHandlerView.layoutIfNeeded()
                self._view.setNeedsLayout()
                self._view.layoutIfNeeded()
                
                let alert = UIAlertController(
                    title: "Canсel",
                    message: message,
                    preferredStyle: .alert
                )
                alert
                    .addAction(
                        UIAlertAction(
                            title: "OK",
                            style: .cancel
                        )
                    )
                debugPrint("cancelCallback, show alert\n")
                self.paymentViewController?.present(alert, animated: true)
            }
    }
    
    public func successCallback(_ data: [String: Any]?) {
        debugPrint("successCallback\n")
        DispatchQueue.main.async {
            self.paymentViewController?.view.isHidden = true
            self._view.paymentSuccessfullLabel.isHidden = false
            self.paymentViewController?.view.setNeedsLayout()
            self.paymentViewController?.view.layoutIfNeeded()
            self._view.heightHandlerView.setNeedsLayout()
            self._view.heightHandlerView.layoutIfNeeded()
            self._view.setNeedsLayout()
            self._view.layoutIfNeeded()
            let alert = UIAlertController(
                title: "Success",
                message: data?.debugDescription ?? "",
                preferredStyle: .alert
            )
            alert
                .addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .cancel
                    )
                )
            debugPrint("successCallback, showing alert\n")
            
            self.paymentViewController?.present(alert, animated: true)
        }
    }
}

private class CheckoutContainerView: UIView {
    let paymentSuccessfullLabel: UILabel
    let heightHandlerView: CheckoutHeightHandlerView
    
    override init(frame: CGRect) {
        paymentSuccessfullLabel = UILabel()
        heightHandlerView = CheckoutHeightHandlerView()
        super.init(frame: frame)
        
        paymentSuccessfullLabel.center = self.center
        paymentSuccessfullLabel.textAlignment = .center
        paymentSuccessfullLabel.text = NSLocalizedString("payment_done",
                                                         tableName: "Localizable",
                                                         bundle: Bundle(for: Self.self),
                                                         comment: "")
        paymentSuccessfullLabel.font = paymentSuccessfullLabel.font.withSize(17)
        paymentSuccessfullLabel.isHidden = true
        paymentSuccessfullLabel.translatesAutoresizingMaskIntoConstraints =
        false
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
        heightHandlerView.addSubview(checkoutView)
        heightHandlerView.addSubview(paymentSuccessfullLabel)
        
        paymentSuccessfullLabel.centerXAnchor.constraint(
            equalTo: self.centerXAnchor
        ).isActive = true
        
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
        debugPrint("layoutSubviews, parent: \(String(describing: self))")
        self.subviews.forEach {
            let subview = $0
            debugPrint("layoutSubviews, child: \(String(describing: subview))\n \(subview.accessibilityIdentifier)")
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
        
        debugPrint("layoutSubviews, bounds: \(self.bounds)")
        onHeightChanged?(
            Int(self.bounds.height)
        )
    }
}
