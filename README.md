# SwiftyPlayer

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)
[![pod 1.3.1](https://img.shields.io/badge/pod-1.3.1-blue.svg)]()
[![Swift 4](https://img.shields.io/badge/Swift-4.0.x-orange.svg)]()

[![TheMindStudios](https://github.com/TheMindStudios/WheelPicker/blob/master/logo.png?raw=true)](https://themindstudios.com/)

A simple yet customizable player used to manage the playback and timing of a media asset. SwiftyPlayer helps to create a custom interface to control the player’s transport behavior such as its ability to play, pause, change the playback rate, and seek to various points in time within the media’s timeline. Or you can also set AVPlayerViewControllerPlayer for default interface. You can use an SwiftyPlayer to play local and remote file-based media, such as QuickTime movies and MP3 audio files, as well as audiovisual media served using HTTP Live Streaming.

## Features

- [x] Easy to use
- [x] Full customization the control player's
- [x] General State Observations through methods of delegate
- [x] Timed State Observations through methods of delegate
- [x] Buffering State Observations through methods of delegate
- [x] Usage all power AVPlayer
- [x] Ability to set AVPlayerViewController

## Usage
1. Import `SwiftyPlayer` module to your `ViewController` class

```swift
import SwiftyPlayer
```
2. Instantiate and set `playerLayer` and `videoGravity`

```swift
let player = Player()
player.setPlayer(to: playerLayerView.playerLayer)
playerLayerView.playerLayer.videoGravity = .resizeAspect
```

3. Set `delegate` and `bufferingDelegate` if need

```swift
player.delegate = self
player.bufferingDelegate = self
```

4. Set the `URL` or `AVPlayerItem` or `AVAsset` to player

```swift

	player.URL = playerURL
	or 
	player.playerItem = playerItem
	or
	player.asset = playerAsset

```

5. Create a custom interface with controls and set relevant commands to `SwiftyPlayer`

```swift
    @IBAction func play() {
        player.play()
    }
    
    @IBAction func pause() {
        player.pause()
    }

    @IBAction func didSlide(_ sender: UISlider) {
	    player.seek(to: sender.value, shouldAutoPlay: true)
    }
```

6. Add a handler for `PlayerDelegate` if need

```swift
    func player(_ player: Player, didUpdateTime timePlayed: Double) {
    	// handle to update played time
    	print(timePlayed)
    }

    func player(_ player: Player, didChangePlaybackState playbackState: PlaybackState) {
    	// handle to update playbackState
    	print(playbackState)
    }

    func playerDidPlayToEnd(_ player: Player) {
    	// handle an event when player did play to end
    }

    func playerDidUpdatePlayerItem(_ player: Player) {
    	// handle an event when player did update item
    }
```

6. Add a handler for `PlayerBufferingDelegate` if need

```swift
    func player(_ player: Player, didChangeBufferingState bufferingState: BufferingState) {
		// handle to update bufferingState
		print(bufferingState)
    }

    func playerDidUpdateBufferingProgress(_ player: Player) {
		// handle to update bufferingProgress
		print(player.bufferingProgress)
    }
```

## Installation with CocoaPods

To install via `CocoaPods` add this lines to your `Podfile`. You need `CocoaPods` v. 1.3.1 or higher

```bash
$ gem install cocoapods
```

#### Podfile

To integrate `SwiftyPlayer` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'TargetName' do
  pod 'SwiftyPlayer', '~> 1.0'
end
```

Then, run the following command:

```bash
$ pod install
```

## License

SwiftyPlayer is available under the MIT license. See the LICENSE file for more info.
