//
//  SwiftyPlayer+AVKit.swift
//  Pods
//
//  Created by Max Mashkov on 9/9/16.
//
//

import Foundation
import AVKit

public extension SwiftyPlayer.Player {
    
    public func setAVPlayerViewControllerPlayer(playerViewController: AVPlayerViewController) {
        playerViewController.player = avPlayer
    }
}
