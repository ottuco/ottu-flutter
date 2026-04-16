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
        let viewFactory = CheckoutViewFactory(
            messenger: registrar.messenger()
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
