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
    
    private let engineGroup = FlutterEngineGroup(name: "checkout-nested-group", project: nil)
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    @MainActor public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {

        let options = FlutterEngineGroupOptions()
                options.initialRoute = "/merchantNestedWidget"
                let nestedEngine = engineGroup.makeEngine(with: options)
                nestedEngine.run()

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
