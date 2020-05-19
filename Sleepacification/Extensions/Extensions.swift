//
//  Extensions.swift
//  Sleepacification
//
//  Created by Dmitriy Lupych on 17.05.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import Foundation

extension Int {
    func stringFormattedTime() -> String {
        let stringTime = String(self)
        return stringTime.count < 2 ? "0" + stringTime : stringTime
    }
}

extension Double {
    func toString() -> String {
        String(Int(self))
    }
}

extension TimeInterval {
    static let day = 86400.0
}
