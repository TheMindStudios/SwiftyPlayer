//
//  Player.swift
//  Rolik
//
//  Created by Max Mashkov on 1/28/16.
//  Copyright © 2016 TheMindStudios. All rights reserved.
//

import Foundation
import AVFoundation
import CoreMedia
import AVKit

public protocol PlayerDelegate: class {
    func player(_ player: Player, didUpdateTime timePlayed: Double)
    func player(_ player: Player, didChangePlaybackState playbackState: PlaybackState)
    func playerDidPlayToEnd(_ player: Player)
    func playerDidUpdatePlayerItem(_ player: Player)
}

public protocol PlayerBufferingDelegate: class {
    func player(_ player: Player, didChangeBufferingState bufferingState: BufferingState)
    func playerDidUpdateBufferingProgress(_ player: Player)
}

open class Player {

    public weak var delegate: PlayerDelegate?
    public weak var bufferingDelegate: PlayerBufferingDelegate?

    let avPlayer = AVPlayer()
    fileprivate var periodicTimeObserver: Any?

    public internal(set) var playbackState: PlaybackState = .stopped {
        didSet {
            delegate?.player(self, didChangePlaybackState: playbackState)
        }
    }

    public internal(set) var bufferingState: BufferingState = .delayed {
        didSet {
            bufferingDelegate?.player(self, didChangeBufferingState: bufferingState)
        }
    }

    public var maximumDuration: TimeInterval! {
        if let playerItem = playerItem {
            return playerItem.duration.seconds
        } else {
            return kCMTimeIndefinite.seconds
        }
    }

    public var isPlaying: Bool {
        return avPlayer.rate > 0.0
    }

    public var muted: Bool {
        get {
            return avPlayer.isMuted
        }
        set {
            avPlayer.isMuted = newValue
        }
    }

    public var volume: Float {
        get {
            return avPlayer.volume
        }
        set {
            avPlayer.volume = newValue
        }
    }

    public var actionAtItemEnd: AVPlayerActionAtItemEnd {

        get {
            return avPlayer.actionAtItemEnd
        }

        set {
            avPlayer.actionAtItemEnd = newValue
        }
    }

    public var asset: AVAsset? {
        get {
            return playerItem?.asset
        }

        set {

            guard let asset = newValue else {
                playerItem = nil
                return
            }

            playerItem = AVPlayerItem(asset: asset)
        }
    }

    public var playerItem: AVPlayerItem? {
        get {
            return avPlayer.currentItem
        }

        set {
            if isPlaying {
                pause()
            }

            setup(playerItem: newValue)
            delegate?.playerDidUpdatePlayerItem(self)
        }
    }

    public var URL: URL? {
        get {
            return (playerItem?.asset as? AVURLAsset)?.url
        }

        set {
            guard let URL = newValue else {

                playerItem = nil

                return
            }

            playerItem = AVPlayerItem(url: URL)
        }
    }

    public var updateInterval: TimeInterval = 0.1 {
        didSet {
            setupPeriodicTimeObserver()
        }
    }

    public var timePlayed: Double {

        guard let playerItem = playerItem else {
            return 0.0
        }

        let currentTime = playerItem.currentTime()

        let currentTimeValue = currentTime.seconds

        guard currentTime.isValid && currentTimeValue.isFinite && !currentTimeValue.isNaN else {
            return 0.0
        }

        return currentTimeValue
    }

    public var timeLeft: Double {
        return duration - timePlayed
    }

    public var duration: Double {

        guard let playerItem = playerItem else {
            return 0.0
        }

        let playerItemDuration = playerItem.duration

        let duration = playerItemDuration.seconds

        guard playerItemDuration.isValid && duration.isFinite && !duration.isNaN else {
            return 0.0
        }

        return duration
    }

    public var progress: Float {
        guard duration > 0.0 else {
            return 0.0
        }

        return Float(timePlayed / duration)
    }

    public var bufferingProgress: Float {

        guard let playerItem = playerItem else {
            return 0.0
        }

        guard duration > 0.0 else {
            return 0.0
        }

        var loadedDuration: TimeInterval = 0.0

        for loadedTimeRange in playerItem.loadedTimeRanges {

            loadedDuration += loadedTimeRange.timeRangeValue.duration.seconds
        }

        return Float(loadedDuration / duration)
    }

    public var startSecond: TimeInterval = 0.0 {
        didSet {
            reset()
        }
    }

    public var endSecond: TimeInterval = 0.0 {
        didSet {
            if let playerItem = playerItem {
                setupEndTime(for: playerItem)
            }
        }
    }

    public fileprivate(set) var isSeeking: Bool = false
    private var playerObserver: PlayerObserver!

    deinit {

        if let periodicTimeObserver = periodicTimeObserver {
            avPlayer.removeTimeObserver(periodicTimeObserver)
        }

        periodicTimeObserver = nil

        NotificationCenter.default.removeObserver(self)
        
        avPlayer.removeObserver(playerObserver, forKeyPath: #keyPath(AVPlayer.rate), context: nil)
        avPlayer.removeObserver(playerObserver, forKeyPath: #keyPath(AVPlayer.status), context: nil)
        avPlayer.removeObserver(playerObserver, forKeyPath: #keyPath(AVPlayer.currentItem.playbackBufferEmpty), context: nil)
        avPlayer.removeObserver(playerObserver, forKeyPath: #keyPath(AVPlayer.currentItem.playbackLikelyToKeepUp), context: nil)
        avPlayer.removeObserver(playerObserver, forKeyPath: #keyPath(AVPlayer.currentItem.loadedTimeRanges), context: nil)
        avPlayer.removeObserver(playerObserver, forKeyPath: #keyPath(AVPlayer.currentItem), context: nil)
        avPlayer.pause()
    }

    public init() {
        
        playerObserver = PlayerObserver(player: self)

        actionAtItemEnd = .pause

        setupPeriodicTimeObserver()
        
        avPlayer.addObserver(playerObserver, forKeyPath: #keyPath(AVPlayer.rate), options: ([.new, .old]) , context: nil)
        avPlayer.addObserver(playerObserver, forKeyPath: #keyPath(AVPlayer.status), options: ([.new, .old]) , context: nil)
        avPlayer.addObserver(playerObserver, forKeyPath: #keyPath(AVPlayer.currentItem.playbackBufferEmpty), options: ([.new, .old]) , context: nil)
        avPlayer.addObserver(playerObserver, forKeyPath: #keyPath(AVPlayer.currentItem.playbackLikelyToKeepUp), options: ([.new, .old]) , context: nil)
        avPlayer.addObserver(playerObserver, forKeyPath: #keyPath(AVPlayer.currentItem.loadedTimeRanges), options: ([.new, .old]) , context: nil)
        avPlayer.addObserver(playerObserver, forKeyPath: #keyPath(AVPlayer.currentItem), options: ([.new, .old]) , context: nil)
    }
}

public extension Player {

    func togglePlay() {
        isPlaying ? pause() : play()
    }

    func play() {
        avPlayer.play()
        playbackState = .playing
    }

    func pause() {
        avPlayer.pause()
        playbackState = .paused
    }

    func reset() {
        pause()
        seek(to: startSecond, shouldAutoPlay: false)
    }

    func seek(to seconds: Double, shouldAutoPlay: Bool, completionHandler: ((_ finished: Bool, _ wasPlaying: Bool) -> Void)? = nil){

        guard let playerItem = playerItem, avPlayer.status == .readyToPlay else {
            completionHandler?(false, false)
            return
        }

        let seekTime = CMTime(seconds: seconds, preferredTimescale: playerItem.asset.duration.timescale)

        guard seekTime.isValid else {
            completionHandler?(false, false)
            return
        }

        let wasPlaying = isPlaying

        isSeeking = true

        playerItem.cancelPendingSeeks()

        let tolerance = kCMTimeZero
        playerItem.seek(to: seekTime, toleranceBefore: tolerance, toleranceAfter: tolerance) { [weak self] finished in

            self?.isSeeking = false

            if let strongSelf = self {
                strongSelf.delegate?.player(strongSelf, didUpdateTime: strongSelf.timePlayed)
            }

            if wasPlaying && shouldAutoPlay {
                self?.play()
            }

            completionHandler?(finished, wasPlaying)
        }

    }

    func seek(to progress: Float, shouldAutoPlay: Bool, completionHandler: ((_ finished: Bool, _ wasPlaying: Bool) -> Void)? = nil) {

        let seconds = Double(progress) * duration

        seek(to: seconds, shouldAutoPlay: shouldAutoPlay, completionHandler: completionHandler)
    }
}

extension Player {

    fileprivate func setupPeriodicTimeObserver() {

        if let periodicTimeObserver = periodicTimeObserver {
            avPlayer.removeTimeObserver(periodicTimeObserver)
        }

        if updateInterval > 0.0 {

            periodicTimeObserver = avPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: updateInterval, preferredTimescale: Int32(NSEC_PER_SEC)), queue: DispatchQueue.main) { [weak self] time in

                self?.timeObserverFired()
            }
        }
    }

    fileprivate func timeObserverFired() {

        guard !isSeeking else {
            return
        }

        delegate?.player(self, didUpdateTime: timePlayed)
        
        if timePlayed > 0.0, bufferingState == .delayed {
            bufferingState = .ready
        }
    }

    fileprivate func setup(asset: AVAsset) {

        setup(playerItem: AVPlayerItem(asset:asset))
    }

    fileprivate func setup(playerItem: AVPlayerItem?) {

        defer {
            avPlayer.replaceCurrentItem(with: playerItem)
        }

        bufferingState = .delayed

        if let currentPlayerItem = self.playerItem {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemPlaybackStalled, object: currentPlayerItem)
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: currentPlayerItem)
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemFailedToPlayToEndTime, object: currentPlayerItem)
        }

        guard let playerItem = playerItem else {
            return
        }

        setupEndTime(for: playerItem)

        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemFailedToPlayToEndTime), name: .AVPlayerItemFailedToPlayToEndTime, object: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playbackDidStall), name: .AVPlayerItemPlaybackStalled, object: playerItem)
    }
    
    fileprivate func setupEndTime(for playerItem: AVPlayerItem) {
        if endSecond > 0.0 {
            playerItem.forwardPlaybackEndTime = CMTime(seconds: endSecond, preferredTimescale: playerItem.asset.duration.timescale)
        } else {
            playerItem.forwardPlaybackEndTime = kCMTimeInvalid
        }
    }
}

extension Player {
    
    // MARK: - Notifications
    
    @objc fileprivate func playerItemDidPlayToEndTime(aNotification: NSNotification) {
        playbackState = .stopped
        delegate?.playerDidPlayToEnd(self)
        
        reset()
    }
    
    @objc fileprivate func playerItemFailedToPlayToEndTime(aNotification: NSNotification) {
        playbackState = .failed(error: avPlayer.currentItem?.error)
    }
    
    @objc fileprivate func playbackDidStall(notification: NSNotification) {
        bufferingState = .delayed
    }
}


