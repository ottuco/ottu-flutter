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
        let viewFactory = CheckoutViewFactory(
            messenger: registrar.messenger()
        )
        registrar
            .register(
                viewFactory,
                withId: "OttuCheckoutWidget"
            )
    }
}
