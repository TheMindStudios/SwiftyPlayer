#
# Be sure to run `pod lib lint SwiftyPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftyPlayer'
  s.version          = '1.0.0'
  s.summary          = 'A simple yet customizable player used to manage the playback and timing of a media asset. Works on iOS 9 and higher'
  s.description      = 'SwiftyPlayer helps to create a custom interface to control the player’s transport behavior such as its ability to play, pause, change the playback rate, and seek to various points in time within the media’s timeline'

  s.social_media_url = 'https://twitter.com/TheMindStudios'
  s.homepage         = 'https://github.com/TheMindStudios/SwiftyPlayer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Max Mashkov' => 'max@themindstudios.com' }
  s.source           = { :git => 'https://github.com/TheMindStudios/SwiftyPlayer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'SwiftyPlayer/Classes/Core/*.swift'
  s.frameworks = ['AVFoundation', 'CoreMedia', 'AVKit']
  s.swift_version = '4.0'

end
