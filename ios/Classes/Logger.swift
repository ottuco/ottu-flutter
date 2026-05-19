//
//  Logger.swift
//  ottu_checkout_sdk
//
//  Created by Ottu on 04.02.2026.
//

import OSLog

internal extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    public static let sdk = Logger(subsystem: subsystem, category: "flutter-sdk")
}
