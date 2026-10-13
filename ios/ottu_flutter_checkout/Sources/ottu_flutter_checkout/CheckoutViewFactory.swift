//
//  CheckoutViewFactory.swift
//  Runner
//
//  Created by Vi on 25.09.2024.
//

import Flutter
import Foundation

public class CheckoutViewFactory: NSObject,
                                  @preconcurrency FlutterPlatformViewFactory
{
    
    private var messenger: FlutterBinaryMessenger
    
    private lazy var engineGroup = FlutterEngineGroup(name: "checkout-nested-group", project: nil)
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    @MainActor public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {

        let creationParams = args as? [String: Any]
        let merchantWidgetRoute = creationParams?["merchantWidgetRoute"] as? String
        let nestedEngine: FlutterEngine?
        if let merchantWidgetRoute, !merchantWidgetRoute.isEmpty {
            let options = FlutterEngineGroupOptions()
            options.initialRoute = merchantWidgetRoute
            nestedEngine = engineGroup.makeEngine(with: options)
        } else {
            nestedEngine = nil
        }

        return CheckoutPlatformView(
            messenger: messenger,
            frame: frame,
            viewId: viewId,
            args: args,
            nestedEngine: nestedEngine,
        )
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
