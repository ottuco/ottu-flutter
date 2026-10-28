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

    private let payButtonCoordinator: PayButtonCoordinator

    init(messenger: FlutterBinaryMessenger, payButtonCoordinator: PayButtonCoordinator) {
        self.payButtonCoordinator = payButtonCoordinator
        self.messenger = messenger
        super.init()
    }

    @MainActor public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return CheckoutPlatformView(
            messenger: messenger,
            frame: frame,
            viewId: viewId,
            args: args,
            payButtonCoordinator: payButtonCoordinator
        )
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
