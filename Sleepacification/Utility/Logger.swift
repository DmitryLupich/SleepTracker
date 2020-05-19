//
//  Logger.swift
//  Sleepacification
//
//  Created by Dmitriy Lupych on 18.05.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import Foundation

enum LogType: String {
    case error = "⛔️ Error: "
    case info  = "💎 Info: "
}

struct Logger {
    static func log(message: String = "", value: Any, logType: LogType = .info) {
        let text: String = logType.rawValue + message + " \(value)"
        consoleLog(text)
    }

    private static func consoleLog(_ message: String) {
        let consoleLog = spacing + message + spacing
        print(consoleLog)
    }

    private static let spacing = "\n---------------------------------\n"
}
