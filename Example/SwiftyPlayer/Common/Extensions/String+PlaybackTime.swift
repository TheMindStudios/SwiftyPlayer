//
//  String+PlaybackTime.swift
//  SwiftyPlayer_Example
//
//  Created by Sergey Degtyar on 11/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

private let secondsPerMinute: Int = 60
private let minutesPerHour: Int = 60
private let secondsPerHour: Int = 3600
private let hoursPerDay: Int = 24
private let secondsPerHalfAnHour: Int = secondsPerHour / 2

extension String {
    
    static func playbackTimeString(for timeInterval: TimeInterval) -> String {
        
        let interval = Int(round(timeInterval))
        
        let hours: Int = (interval / secondsPerHour) % hoursPerDay
        let minutes: Int = (interval / secondsPerMinute) % minutesPerHour
        let seconds: Int = interval % secondsPerMinute
        
        if hours > 0 {
            return String(format: "%d:%.2d:%.2d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%.2d", minutes, seconds)
        }
    }
}
