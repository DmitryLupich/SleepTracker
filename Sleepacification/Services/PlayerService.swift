//
//  PlayerService.swift
//  Sleepacification
//
//  Created by Dmitriy Lupych on 17.05.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import Foundation
import AVFoundation

enum SoundType {
    case alarm
    case empty
    case rain
}

protocol Playable: class {
    func play(sound: SoundType)
    func stop()
}

final class PlayerService: NSObject {
    enum Constants {
        static let alarmfileName = "alarm"
        static let emptyfileName = "empty"
        static let rainfileName = "rain"

        static let fileExtention = "mp3"
    }
    private let bundle =  Bundle.main
    private var player: AVAudioPlayer?

    private func play(_ url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.prepareToPlay()
            player?.delegate = self
            player?.play()
        } catch {
            //TODO: - Handle error
            Logger.log(value: error, logType: .error)
        }
    }
}

extension PlayerService: Playable {
    func play(sound: SoundType) {
        var fileName = String()
        switch sound {
        case .rain:
            fileName = Constants.rainfileName
        case .empty:
            fileName = Constants.emptyfileName
        case .alarm:
            fileName = Constants.alarmfileName
        }
        bundle.url(forResource: fileName, withExtension: Constants.fileExtention)
            .map(play(_:))
    }
    
    func stop() {
        player?.stop()
        player = nil
    }
}

extension PlayerService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
}
