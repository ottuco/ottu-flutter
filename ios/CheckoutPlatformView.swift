//
//  CheckoutPlatformView.swift
//  Runner
//
//  Created by Vi on 25.09.2024.
//

import Foundation
import ottu_checkout_sdk

private let checkoutChannelName = "com.ottu.sample/checkout"
private let methodCheckoutHeight = "METHOD_CHECKOUT_HEIGHT"

public class CheckoutPlatformView: NSObject, FlutterPlatformView {
    let viewId: Int64
    let channel: FlutterMethodChannel
    
    private let _view = CheckoutContainerView()
    //private var _paymentViewController:UIViewController?
    
    init(messenger: FlutterBinaryMessenger,
         frame: CGRect,
         viewId: Int64,
         args: Any?) {
        
        //self._view =
        self.viewId = viewId
        self.channel = FlutterMethodChannel(name: checkoutChannelName, binaryMessenger: messenger)
        
        super.init()
        
        createNativeView(view: _view)
        
        self._view.onHeightChanged = {(height:Int) in
            print("CheckoutPlatformView, onHeightChanged: \(height)")
        }
        
        self.channel.setMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch call.method {
            case "receiveFromFlutter":
                guard let args = call.arguments as? [String: Any],
                      let text = args["text"] as? String else {
                    result(FlutterError(code: "-1", message: "Error", details: "Error hapened in view"))
                    return
                }
                //self.magicView.receiveFromFlutter(text)
                result("receiveFromFlutter success")
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    public func sendFromNative(_ text: String) {
        channel.invokeMethod("sendFromNative", arguments: text)
    }
    
    public func view() -> UIView {
        //_view.backgroundColor = .yellow
        return _view
    }
    
    func createNativeView(view _view: UIView){
        //_view.backgroundColor = UIColor.blue
        let nativeLabel = UILabel()
        nativeLabel.text = "Native text from iOS"
        nativeLabel.textColor = UIColor.white
        nativeLabel.textAlignment = .center
        nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        
        let merchantId = "alpha.ottu.net"
        let apiKey = "cHSLW0bE.56PLGcUYEhRvzhHVVO9CbF68hmDiXcPI"
        let sessionId = "946389075a6f7482b3738840320877ef6f887cc4"
        let theme = CheckoutTheme()
        theme.showPaymentDetails = true
        let formsOfPayment = [FormOfPayment.applePay,FormOfPayment.flex, FormOfPayment.tokenPay, FormOfPayment.redirect]
        
        let checkout = Checkout(
            formsOfPayments: formsOfPayment,
            theme: theme,
            sessionId: sessionId,
            merchantId: merchantId,
            apiKey: apiKey,
            setupPreload: nil,
            delegate: self
        )
        let paymentViewController = checkout.paymentViewController()
        
        
        if let pvc = paymentViewController {
            pvc.view.translatesAutoresizingMaskIntoConstraints = false
            _view.addSubview(pvc.view)
            
            NSLayoutConstraint.activate([
                pvc.view.leadingAnchor.constraint(equalTo: self._view.leadingAnchor),
                pvc.view.trailingAnchor.constraint(equalTo: self._view.trailingAnchor),
                pvc.view.topAnchor.constraint(equalTo: self._view.topAnchor),
                pvc.view.bottomAnchor.constraint(equalTo: self._view.bottomAnchor)
            ])
        }
    }
}


extension CheckoutPlatformView: OttuDelegate {
    public func errorCallback(_ data: [String : Any]?) {
        DispatchQueue.main.async {
            //self.paymentContainerView.isHidden = true
            
            let alert = UIAlertController(title: "Error", message: data?.debugDescription ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            //self.present(alert, animated: true)
        }
    }
    
    public func cancelCallback(_ data: [String : Any]?) {
        DispatchQueue.main.async {
            var message = ""
            
            if let paymentGatewayInfo = data?["payment_gateway_info"] as? [String : Any],
               let pgName = paymentGatewayInfo["pg_name"] as? String,
               pgName == "kpay" {
                message = paymentGatewayInfo["pg_response"].debugDescription
            } else {
                message = data?.debugDescription ?? ""
            }
            
            //self.paymentContainerView.isHidden = true
            
            let alert = UIAlertController(title: "Canсel", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            //self.present(alert, animated: true)
        }
    }
    
    public func successCallback(_ data: [String : Any]?) {
        DispatchQueue.main.async {
            //self.paymentContainerView.isHidden = true
            //self.paymentSuccessfullLabel.isHidden = false
            
            let alert = UIAlertController(title: "Success", message: data?.debugDescription ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            //self.present(alert, animated: true)
        }
    }
    
}


private class CheckoutContainerView:UIView {
    
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
        onHeightChanged?(Int(self.bounds.height))
    }
}
