#
# Be sure to run `pod lib lint XKRMStoreHelper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XKRMStoreHelper'
  s.version          = '1.0.0'
  s.summary          = '内购工具'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '基于RMStore封装'

  s.homepage         = 'https://github.com/kunhum/XKRMStoreHelper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kunhum' => 'kunhum@163.com' }
  s.source           = { :git => 'https://github.com/kunhum/XKRMStoreHelper.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'XKRMStoreHelper/Classes/XKRMStoreHelper/*.{h,m}'
  
  # s.resource_bundles = {
  #   'XKRMStoreHelper' => ['XKRMStoreHelper/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.subspec 'RMStore' do |rMStore|
      rMStore.source_files = 'XKRMStoreHelper/Classes/XKRMStoreHelper/RMStore/*.{h,m}'
      rMStore.public_header_files = 'XKRMStoreHelper/Classes/XKRMStoreHelper/RMStore/*.h'
  end
  
end
