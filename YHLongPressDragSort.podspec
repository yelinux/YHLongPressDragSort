#
# Be sure to run `pod lib lint YHLongPressDragSort.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YHLongPressDragSort'
  s.version          = '0.1.0'
  s.summary          = 'Enable long press drag sorting for cell and customView of YHLongPressDragSort.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Enable long press drag sorting for cell and customView.
                       DESC

  s.homepage         = 'https://github.com/yelinux/YHLongPressDragSort'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ye_linux@126.com' => 'ye_linux@126.com' }
  s.source           = { :git => 'https://github.com/yelinux/YHLongPressDragSort.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'YHLongPressDragSort/Classes/**/*'
  
  # s.resource_bundles = {
  #   'YHLongPressDragSort' => ['YHLongPressDragSort/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
