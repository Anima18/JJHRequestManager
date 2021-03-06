#
# Be sure to run `pod lib lint JJHRequest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, bJJH their use is encouraged
# To learn more aboJJH a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JJHRequest'
  s.version          = '0.1.0'
  s.summary          = 'A short description of JJHRequest.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry aboJJH the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Anima18/JJHRequest'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anima18' => '591151451@qq.com' }
  s.source           = { :git => 'https://github.com/Anima18/JJHRequest.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JJHRequest/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JJHRequest' => ['JJHRequest/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'AFNetworking', '~> 3.0'
  s.dependency 'MBProgressHUD', '~> 1.0.0'
  s.dependency 'YYModel', '~> 1.0.0'
  s.dependency 'ReactiveObjC', '~> 3.0.0'
end
