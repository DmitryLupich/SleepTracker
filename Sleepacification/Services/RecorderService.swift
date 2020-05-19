//
//  RecorderService.swift
//  Sleepacification
//
//  Created by Dmitriy Lupych on 18.05.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import Foundation
import AVFoundation

protocol Recordable: class {
    func record()
    func stop()
    func requestPermission(completion: @escaping (Bool) -> Void)
}

final class RecorderService: NSObject {
    private let audioSession = AVAudioSession.sharedInstance()
    private var audioRecorder: AVAudioRecorder?
}

extension RecorderService: Recordable {
    func requestPermission(completion: @escaping (Bool) -> Void) {
        audioSession.requestRecordPermission(completion)
    }

    func record() {
        do {
            try audioSession.setCategory(.playAndRecord)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            //TODO: - Handle error
            Logger.log(value: error, logType: .error)
        }

        let documents = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                            FileManager.SearchPathDomainMask.userDomainMask,
                                                            true)[0]

        let stringPath = documents.appending("/sleep.m4a")
        guard let url = URL(string: stringPath) else { return }

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        } catch {
            Logger.log(value: error, logType: .error)
        }
    }

    func stop() {
        audioRecorder?.stop()
    }
}

extension RecorderService: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        Logger.log(message: "audioRecorderDidFinishRecording", value: flag, logType: .info)
    }
}
