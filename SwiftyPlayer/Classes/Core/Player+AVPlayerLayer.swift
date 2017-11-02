//
//  Player+AVPlayerLayer.swift
//  Pods-SwiftyPlayer_Example
//
//  Created by Max Mashkov on 7/11/17.
//

import Foundation
import AVFoundation

extension Player {
    
    public func setPlayer(to playerLayer: AVPlayerLayer) {
        playerLayer.player = avPlayer
    }
}
