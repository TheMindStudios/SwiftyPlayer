//
//  Player+AVKit.swift
//  SwiftyPlayer
//
//  Created by Max Mashkov on 7/11/17.
//

import Foundation
import AVKit

extension Player {
    
    public func setPlayer(to playerViewController: AVPlayerViewController) {
        playerViewController.player = avPlayer
    }
}
