//
//  FullscreenVideoPlayerViewController.swift
//  SwiftyPlayer_Example
//
//  Created by Sergey Degtyar on 11/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyPlayer

final class FullscreenVideoPlayerViewController: UIViewController {
    
    @IBOutlet var topHUDView: UIView!
    @IBOutlet var bottomHUDView: UIView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var slider: VideoPlayerSlider!
    @IBOutlet var timePlayedLabel: UILabel!
    @IBOutlet var timeLeftLabel: UILabel!
    @IBOutlet var playerLayerView: VideoPlayerLayerView!
    @IBOutlet var backgroundTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var backgroundDoubleTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet var topContainerView: UIView!
    @IBOutlet var bottomContainerView: UIView!
    
    private var topCustomView: UIView?
    private var bottomCustomView: UIView?
    
    private(set) var isHUDhidden: Bool = false
    private lazy var player: Player = {
       let player = Player()
        player.delegate = self
        return player
    }()
    private var isTracking: Bool = false
    
    public var itemURL: URL?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundTapGestureRecognizer.require(toFail: backgroundDoubleTapGestureRecognizer)
        playerLayerView.playerLayer.videoGravity = .resizeAspect
        player.setPlayer(to: playerLayerView.playerLayer)
        
        if let itemURL = itemURL {
            player.URL = itemURL
            playVideo()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    @available(iOS 11.0, *)
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    func setCustomViews(top view: UIView?, bottom: UIView?) {
        topCustomView = view
        bottomCustomView = bottom
    }
}

// MARK: - Actions

extension FullscreenVideoPlayerViewController {
    
    @IBAction func play() {
        playVideo()
    }
    
    @IBAction func pause() {
        pauseVideo()
    }
    
    @IBAction func backgroundTapGestureAction(_ gesture: UITapGestureRecognizer) {
        if isHUDhidden {
            showHUDView(animated: true)
            player.isPlaying ? showPauseButton(animated: true) : showPlayButton(animated: true)
        } else {
            hideHUDView(animated: true)
            hidePlayButton(animated: true)
            hidePauseButton(animated: true)
        }
    }
    
    @IBAction func backgroundDoubleTapGestureAction(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didStartSlide() {
        isTracking = true
    }
    
    @IBAction func didSlide(_ sender: UISlider) {
        isTracking = sender.isTracking
        seek(to: sender.value, isTracking: sender.isTracking)
    }
    
    @IBAction func closePlayer() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - View logic

extension FullscreenVideoPlayerViewController {
    
    func showHUDView(animated: Bool) {
        
        isHUDhidden = false
        
        UIView.animate(withDuration: animated ? 0.3 : 0) { [weak self] in
            self?.topHUDView.alpha = 1
            self?.bottomHUDView.alpha = 1
        }
    }
    
    func hideHUDView(animated: Bool) {
        
        isHUDhidden = true
        
        UIView.animate(withDuration: animated ? 0.3 : 0) { [weak self] in
            self?.topHUDView.alpha = 0
            self?.bottomHUDView.alpha = 0
        }
    }
    
    func showPlayButton(animated: Bool) {
        
        UIView.animate(withDuration: animated ? 0.2 : 0) { [weak self] in
            self?.playButton.alpha = 1
        }
    }
    
    func hidePlayButton(animated: Bool) {
        
        UIView.animate(withDuration: animated ? 0.2 : 0) { [weak self] in
            self?.playButton.alpha = 0
        }
    }
    
    func showPauseButton(animated: Bool) {
        
        UIView.animate(withDuration: animated ? 0.2 : 0) { [weak self] in
            self?.pauseButton.alpha = 1
        }
    }
    
    func hidePauseButton(animated: Bool) {
        
        UIView.animate(withDuration: animated ? 0.2 : 0) { [weak self] in
            self?.pauseButton.alpha = 0
        }
    }
    
    func showError(withMessage message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
    }
    
    func setProgress(withValue value: Float) {
        slider.setValue(value, animated: true)
    }
    
    func setTimePlayed(_ timePlayed: String, timeLeft: String) {
        timePlayedLabel.text = timePlayed
        timeLeftLabel.text = timeLeft
    }
}

// MARK: - Player logic

extension FullscreenVideoPlayerViewController {
    
    func setupPlayer(for playerLayer: AVPlayerLayer) {
        player.setPlayer(to: playerLayer)
    }
    
    func playVideo() {
        player.play()
    }
    
    func pauseVideo() {
        player.pause()
    }
    
    func seek(to progress: Float, isTracking: Bool) {
        
        player.pause()
        player.seek(to: progress, shouldAutoPlay: false) { [weak self] _, _ in
            if !isTracking {
                self?.play()
            }
        }
    }
}

// MARK: - PlayerDelegate

extension FullscreenVideoPlayerViewController: PlayerDelegate {
    
    func player(_ player: Player, didUpdateTime timePlayed: Double) {
        
        let timePlayed = String.playbackTimeString(for: TimeInterval(timePlayed))
        let timeLeft = String.playbackTimeString(for: TimeInterval(player.timeLeft))
        
        setTimePlayed(timePlayed, timeLeft: timeLeft)
        setProgress(withValue: player.progress)
    }
    
    func player(_ player: Player, didChangePlaybackState playbackState: PlaybackState) {
        
        switch playbackState {
        case .playing:
            if !isTracking {
                hideHUDView(animated: true)
                hidePlayButton(animated: true)
                hidePauseButton(animated: true)
            }
        case .paused, .stopped:
            showPlayButton(animated: true)
            hidePauseButton(animated: true)
        case .failed(let error):
            if let error = error {
                showError(withMessage: error.localizedDescription)
            }
        }
    }
    
    func playerDidPlayToEnd(_ player: Player) {
        player.reset()
        showPlayButton(animated: true)
        showHUDView(animated: true)
    }
    
    func playerDidUpdatePlayerItem(_ player: Player) {
        
    }
}

