#
# Be sure to run `pod lib lint SYZFileManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SYZFileManager'
  s.version          = '0.1.0'
  s.summary          = '文件存储管理'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/sundasheng1985/SYZFileManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sundasheng1985' => '641569408@qq.com' }
  s.source           = { :git => 'https://github.com/sundasheng1985/SYZFileManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SYZFileManager/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SYZFileManager' => ['SYZFileManager/Assets/*.png']
  # }

  s.dependency 'SYZUIBasekit'
  s.dependency 'SSZipArchive', '2.1.3'
end
