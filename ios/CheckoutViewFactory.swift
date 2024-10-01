//
//  CheckoutViewFactory.swift
//  Runner
//
//  Created by Vi on 25.09.2024.
//

import Foundation

class CheckoutViewFactory: NSObject, FlutterPlatformViewFactory {
    
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }
    
    public func create(withFrame frame: CGRect,
                       viewIdentifier viewId: Int64,
                       arguments args: Any?) -> FlutterPlatformView {
        return CheckoutPlatformView(messenger: messenger,
                                    frame: frame, viewId: viewId,
                                    args: args)
    }
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
