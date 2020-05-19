//
//  DateService.swift
//  Sleepacification
//
//  Created by Dmitriy Lupych on 18.05.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import Foundation

struct DateService {
    private let hours: Int
    private let minutes: Int
    private let calendar = Calendar.current

    init(hours: Int, minutes: Int) {
        self.hours = hours
        self.minutes = minutes
    }

    func alarmDate() -> Date? {
        //TODO: - Fix offset for time zone
        let currentDate = Date()
        let componentsSet: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        var components = calendar.dateComponents(componentsSet, from: currentDate)

        components.timeZone = TimeZone(abbreviation: "UTC")
        components.hour = hours
        components.minute = minutes

        guard var alarmDate = calendar.date(from: components) else { return nil }
        if alarmDate < currentDate {
            alarmDate.addTimeInterval(.day)
        }
        return alarmDate
    }
}
