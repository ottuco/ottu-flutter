//
//  CheckoutViewPlugin.swift
//  Runner
//
//  Created by Vi on 25.09.2024.
//

import Flutter
import Foundation
import UIKit

public class CheckoutViewPlugin: NSObject, FlutterPlugin {
    public static func register(
        with registrar: FlutterPluginRegistrar
    ) {
        print("CheckoutViewPlugin, registering")
        let payButtonCoordinator = PayButtonCoordinator()
        let viewFactory = CheckoutViewFactory(
            messenger: registrar.messenger(),
            payButtonCoordinator: payButtonCoordinator
        )
        registrar.register(
            PayButtonViewFactory(
                messenger: registrar.messenger(),
                coordinator: payButtonCoordinator
            ),
            withId: "PayButtonWidget"
        )
        registrar
            .register(
                viewFactory,
                withId: "OttuCheckoutWidget"
            )
    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        print("CheckoutViewPlugin detached from engine.")
    }
}
