import Flutter
import UIKit
import ottu_checkout_sdk

let channel_checkout = "com.ottu.sample/checkout";
let method_launch_ottu = "launchOttuSdk";

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    //@IBOutlet weak var paymentContainerView: UIView!
    var navigationController: UINavigationController!
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        //CheckoutViewPlugin.register(with: registrar(forPlugin: "Magic")!)
        guard let pluginRegistrar = self.registrar(forPlugin: "CheckoutPlatformView") else {
            return false
        }
        
        let viewFactory = CheckoutViewFactory(
            messenger: pluginRegistrar.messenger()
        )
        pluginRegistrar.register(viewFactory, withId: "CheckoutPlatformView")

        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        
        // create and then add a new UINavigationController
        self.navigationController = UINavigationController(
            rootViewController: controller
        )
        self.window.rootViewController = self.navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.window.makeKeyAndVisible()
        
        let channel = FlutterMethodChannel(
            name: channel_checkout,
            binaryMessenger: controller.binaryMessenger
        )
        channel.setMethodCallHandler(
{
    [weak self] (
        call: FlutterMethodCall,
        result: FlutterResult
    ) -> Void in
        
    guard call.method == method_launch_ottu else {
        result(FlutterMethodNotImplemented)
        return
    }
            
    print("Launch OttuSdk")
            
    let merchantId = "alpha.ottu.net"
    let apiKey = "cHSLW0bE.56PLGcUYEhRvzhHVVO9CbF68hmDiXcPI"
    let sessionId = "9643be7e3edb46c9e06256df780f5be733eca279"
    let theme = CheckoutTheme()
    theme.showPaymentDetails = true

    
    let formsOfPayment = [FormOfPayment]()

    let checkout = Checkout(
        formsOfPayments: formsOfPayment,
        theme: theme,
        sessionId: sessionId,
        merchantId: merchantId,
        apiKey: apiKey,
        setupPreload: nil,
        delegate: self!)

    if let paymentViewController = checkout.paymentViewController(),
       let paymentView = paymentViewController.view {

        //self.addChild(paymentViewController)
        //self.paymentContainerView.addSubview(paymentView)
        //paymentViewController.didMove(toParent: self)

        paymentView.translatesAutoresizingMaskIntoConstraints = false
                
        self!.navigationController.setNavigationBarHidden(false, animated: true)
        self!.navigationController
            .pushViewController(paymentViewController, animated: true)

        NSLayoutConstraint.activate([
            //paymentView.leadingAnchor.constraint(equalTo: self.paymentContainerView.leadingAnchor),
            //self.paymentContainerView.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor),
            //paymentView.topAnchor.constraint(equalTo: self.paymentContainerView.topAnchor),
            //self.paymentContainerView.bottomAnchor.constraint(equalTo: paymentView.bottomAnchor)
        ])
    }
            
        
            
})
        
        return super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
}

extension AppDelegate: OttuDelegate {
    func errorCallback(_ data: [String : Any]?) {
        DispatchQueue.main.async {
            //self.paymentContainerView.isHidden = true
            
            let alert = UIAlertController(
                title: "Error",
                message: data?.debugDescription ?? "",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            //self.present(alert, animated: true)
        }
    }
    
    func cancelCallback(_ data: [String : Any]?) {
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
            
            let alert = UIAlertController(
                title: "Canсel",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            //self.present(alert, animated: true)
        }
    }
    
    func successCallback(_ data: [String : Any]?) {
        DispatchQueue.main.async {
            //self.paymentContainerView.isHidden = true
            //self.paymentSuccessfullLabel.isHidden = false
            
            let alert = UIAlertController(
                title: "Success",
                message: data?.debugDescription ?? "",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            //self.present(alert, animated: true)
        }
    }

}
