//
//  AlarmViewModel.swift
//  Sleepacification
//
//  Created by Dmitriy Lupych on 17.05.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import Foundation

final class AlarmViewModel: ObservableObject {
    enum Constants {
        static let maxHours = 24
        static let maxMinutes = 60
    }

    // MARK: - Properties

    private let notificationService = NotificationService()
    private let hours: [Int] = Array(0...Constants.maxHours * 10)
    private let minutes: [Int] = Array(0...Constants.maxMinutes * 10)

    var hoursCount: Int { hours.count }
    var minutesCount: Int { minutes.count }

    @Published var selectedHour = Int()
    @Published var selectedMinute = Int()
    @Published var showNotificationPermission = false
    @Published var alarmIsSet = false

    // MARK: - Public Methods

    func onAppear() {
        selectedHour = hours[hoursCount/2]
        selectedMinute = minutes[minutesCount/2]
    }

    func toSettings() {
        notificationService.toSettings()
    }

    func setAlarm() -> Date? {
        let normalizedHours = normalized(unit: selectedHour, maxUnit: Constants.maxHours)
        let normalizedMinutes = normalized(unit: selectedMinute, maxUnit: Constants.maxMinutes)
        guard let alarmDate = DateService(hours: normalizedHours,
                                          minutes: normalizedMinutes).alarmDate() else { return nil }

        notificationService
            .setAlarm(date: alarmDate) { isSucceed in
                        self.showNotificationPermission = !isSucceed
                        self.alarmIsSet = isSucceed
        }
        return alarmDate
    }

    func hourTitleFor(_ index: Int) -> String {
        unitsToString(unints: hours,
                      maxUnit: Constants.maxHours,
                      index: index
        )
    }

    func minuteTitleFor(_ index: Int) -> String {
        unitsToString(unints: minutes,
                      maxUnit: Constants.maxMinutes,
                      index: index
        )
    }

    func selectedHourTitle() -> String {
        normalized(unit: selectedHour, maxUnit: Constants.maxHours).stringFormattedTime()
    }

    func selectedMinuteTitle() -> String {
        normalized(unit: selectedMinute, maxUnit: Constants.maxMinutes).stringFormattedTime()
    }

    // MARK: - Private Methods

    private func unitsToString(unints: [Int], maxUnit: Int, index: Int) -> String {
        normalized(unit: unints[index], maxUnit: maxUnit).stringFormattedTime()
    }

    private func normalized(unit: Int, maxUnit: Int) -> Int {
        unit % maxUnit
    }
}
