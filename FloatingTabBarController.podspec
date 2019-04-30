#
# Be sure to run `pod lib lint FloatingTabBarController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FloatingTabBarController'
  s.version          = '0.1.0'
  s.summary          = 'FloatingTabBarController is a tab bar controller with sliding tabs and a custom tab bar.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
`FloatingTabBarController` is a tab bar controller with sliding tabs and a custom tab bar inspired by [this Dribbble shot](https://dribbble.com/shots/4844696-Tab-bar-interaction-with-animated-icons).
                       DESC

  s.homepage         = 'https://github.com/EmilioPelaez/FloatingTabBarController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'EmilioPelaez' => 'me@epelaez.net' }
  s.source           = { :git => 'https://github.com/EmilioPelaez/FloatingTabBarController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/EmilioPelaez'

  s.ios.deployment_target = '11.0'
  s.source_files = 'FloatingTabBarController/Classes/**/*'
  s.swift_version = '5.0'
  s.dependency 'CGMath'
end
