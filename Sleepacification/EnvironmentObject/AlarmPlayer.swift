//
//  AlarmPlayer.swift
//  Sleepacification
//
//  Created by Dmitriy Lupych on 18.05.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import Foundation
import Combine

class AlarmPlayer: ObservableObject {
    private let player: Playable
    private let recorder: Recordable
    private var playerTimer: Timer?
    private var alarmTimer: Timer?

    @Published var sleepTimer = Double()
    @Published var appState = AppState.idle
    @Published var isPlayerStarted = false
    @Published var alarmDate: Date?
    @Published var askRecordingPermission: Void = Void()

    private var cancellable = Set<AnyCancellable>()

    init(player: Playable, recorder: Recordable) {
        self.player = player
        self.recorder = recorder
        setupBindings()
    }

    private var shouldStart: Bool {
        get { isPlayerStarted }
        set { newValue ? start() : pause() }
    }

    private var alarm: Date? {
        get { alarmDate }
        set { addAlarm(to: newValue) }
    }
}

// MARK: - Private Methods

extension AlarmPlayer {
    private func setupBindings() {
        let isPlayerStarted = $isPlayerStarted
            .dropFirst()
            .assign(to: \AlarmPlayer.shouldStart, on: self)

        let alarm = $alarmDate.assign(to: \AlarmPlayer.alarm, on: self)

        let recordingPermission = $askRecordingPermission.sink { _ in
            self.recorder.requestPermission { isAuthorized in
                //TODO: - Handle ok/cancel
                Logger.log(value: isAuthorized, logType: .info)
            }
        }
        
        [isPlayerStarted, alarm, recordingPermission]
            .forEach { $0.store(in: &cancellable) }
    }

    private func start() {
        player.stop()
        player.play(sound: .rain)
        appState = .playing
        playerTimer = Timer.scheduledTimer(
            withTimeInterval: sleepTimer,
            repeats: false,
            block: { [weak self] _ in
                self?.player.stop()
                // Playing empty sound on repeat, to prevent deleting app from the memory
                // Also, trick with location manager (allowsBackgroundLocationUpdates) is an option
                self?.player.play(sound: .empty)
                self?.recorder.record()
                self?.appState = .recording
                Logger.log(message: "Start playing empty sound", value: "", logType: .info)
        })
    }

    private func pause() {
        appState = .paused
        player.stop()
        recorder.stop()
    }

    private func addAlarm(to date: Date?) {
        //TODO: - Handle nil case
        guard let date = date else { return }
        let alarmTimeInterval = date.timeIntervalSince(Date()) - 60*60*3
        alarmTimer = Timer.scheduledTimer(
            withTimeInterval: alarmTimeInterval,
            repeats: false,
            block: { [weak self] _ in
                Logger.log(message: "Alarm fired", value: true, logType: .info)
                self?.player.stop()
                self?.player.play(sound: .alarm)
                self?.appState = .alarm
        })
    }
}
