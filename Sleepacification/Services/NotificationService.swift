//
//  NotificationService.swift
//  Sleepacification
//
//  Created by Dmitriy Lupych on 17.05.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import Foundation
import UIKit.UIApplication
import UserNotifications

final class NotificationService {
    private let notificationCenter = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    private let application = UIApplication.shared
    private let mainQueue = DispatchQueue.main
    private let bundle = Bundle.main

    func setAlarm(date: Date, completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: options) { isAllowed, _ in
            self.mainQueue.async {
                if isAllowed {
                    self.createNotification(timeInterval: date.timeIntervalSince(Date()) - 60*60*3)
                }
                completion(isAllowed)
            }
        }
    }

    func toSettings() {
        URL(string: UIApplication.openSettingsURLString)
            .map{ application.open($0, options: [:]) }
    }

    private func createNotification(timeInterval: TimeInterval) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Alarm"
        notificationContent.body = "Wake up!"
//        notificationContent.badge = NSNumber(value: 1)

        let sleepImage = bundle.url(forResource: "sleep",withExtension: "png")
            .flatMap { try? UNNotificationAttachment(identifier: "sleep",
                                                     url: $0,
                                                     options: nil)
        }

        let rainSound = bundle.url(forResource: "alarm",withExtension: "mp3")
            .flatMap { try? UNNotificationAttachment(identifier: "alarm",
                                                     url: $0,
                                                     options: nil)
        }

        [sleepImage, rainSound].forEach { attachment in
            attachment.map { notificationContent.attachments.append($0) }
        }

        let request = UNNotificationRequest(identifier: "alarm",
                                            content: notificationContent,
                                            trigger: trigger)
        notificationCenter.add(request) { error in
            //TODO: - Handle error
            error.map { Logger.log(value: $0, logType: .error) }
        }
    }
}
