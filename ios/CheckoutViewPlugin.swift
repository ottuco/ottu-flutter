//
//  CheckoutViewPlugin.swift
//  Runner
//
//  Created by Vi on 25.09.2024.
//

import Foundation

public class CheckoutViewPlugin {
 class func register(with registrar: FlutterPluginRegistrar) {
   let viewFactory = CheckoutViewFactory(messenger: registrar.messenger())
   registrar.register(viewFactory, withId: "CheckoutPlatformView")
 }
}
