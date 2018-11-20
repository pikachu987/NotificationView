#
# Be sure to run `pod lib lint NotificationView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NotificationView'
  s.version          = '0.2.0'
  s.summary          = 'iOS Notification View'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
You can easily implement iOS Basic Notification screens.
There is a default theme and a dark theme.
You can attach an image to the Notification screen with only the UIImageView.
You can adjust the disappearance time.
You can get a delegate or callback for the visible and disappearing states.
You can get delegates and callbacks for tap.
                       DESC

  s.homepage         = 'https://github.com/pikachu987/NotificationView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pikachu987' => 'pikachu77769@gmail.com' }
  s.source           = { :git => 'https://github.com/pikachu987/NotificationView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'NotificationView/Classes/**/*'
  s.swift_version = '4.2'

  # s.resource_bundles = {
  #   'NotificationView' => ['NotificationView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
