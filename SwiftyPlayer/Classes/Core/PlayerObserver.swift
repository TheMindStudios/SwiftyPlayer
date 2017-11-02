//
//  PlayerObserver.swift
//  Pods-SwiftyPlayer_Example
//
//  Created by Max Mashkov on 7/11/17.
//

import Foundation
import AVFoundation

final class PlayerObserver: NSObject {
    
    weak var player: Player?
    
    init(player: Player) {
        
        self.player = player
        
        super.init()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let keyPath = keyPath, let player = player else {
            return
        }
        
        switch keyPath {
            
        case #keyPath(AVPlayer.currentItem):
            
            if player.startSecond > 0.0 {
                
                DispatchQueue.main.async { [weak self] in
                    
                    guard let player = self?.player else {
                        return
                    }
                    
                    player.seek(to: player.startSecond, shouldAutoPlay: false)
                }
            }
            
        case #keyPath(AVPlayer.rate):
            
            if player.bufferingState == .ready {
                player.playbackState = player.avPlayer.rate > 0 ? .playing : .paused
            }
            
        case #keyPath(AVPlayer.currentItem.playbackLikelyToKeepUp):
            
            if player.avPlayer.currentItem?.isPlaybackLikelyToKeepUp == true {
                player.bufferingState = .ready
                if player.playbackState == .playing {
                    player.play()
                }
            }
            
        case #keyPath(AVPlayer.status):
            
            switch player.avPlayer.status {
            case .unknown:
                break
            case .readyToPlay:
                if player.playbackState == .playing {
                    player.play()
                }
            case .failed:
                player.playbackState = .failed(error: player.avPlayer.error)
            }
            
        case #keyPath(AVPlayer.currentItem.playbackBufferEmpty):
            
            if let playerItem = player.playerItem {
                if playerItem.isPlaybackBufferEmpty {
                    player.bufferingState = .delayed
                }
            }
            
        case #keyPath(AVPlayer.currentItem.loadedTimeRanges):
            
            player.bufferingDelegate?.playerDidUpdateBufferingProgress(player)
            
        default:
            break
        }
    }
}
