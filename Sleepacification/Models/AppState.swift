//
//  AppState.swift
//  Sleepacification
//
//  Created by Dmitriy Lupych on 17.05.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import Foundation

enum AppState: String {
    case idle, playing, recording, paused, alarm
    var title: String { self.rawValue.capitalized }
}
