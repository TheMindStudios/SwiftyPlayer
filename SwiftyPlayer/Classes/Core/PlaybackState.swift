//
//  PlaybackState.swift
//  Pods-SwiftyPlayer_Example
//
//  Created by Max Mashkov on 7/11/17.
//

import Foundation

public enum PlaybackState: Equatable {
    
    case stopped
    case playing
    case paused
    case failed(error: Error?)
}

public func == (lhs: PlaybackState, rhs: PlaybackState) -> Bool {
    switch (lhs, rhs) {
    case (.stopped, .stopped):
        return true
    case (.playing, .playing):
        return true
    case (.paused, .paused):
        return true
    case (.failed, .failed):
        return true
    default:
        return false
    }
}
