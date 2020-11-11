#
# Be sure to run `pod lib lint SandBoxPreviewTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SandBoxPreviewTool'
  s.version          = '1.2.1'
  s.summary          = 'Make iOS preview sandbox in your app more easy'
  s.description      = <<-DESC
                      help you preview sandbox easy in you application with one line of code
                       DESC
  s.homepage         = 'https://github.com/wjyx1lalala/SandBoxPreviewTool'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "nuomi" => "492838605@qq.com" }
  s.source           = { :git => "https://github.com/wjyx1lalala/SandBoxPreviewTool.git", :tag => "1.2.1" }
  s.ios.deployment_target = '9.0'
  s.source_files     = 'SandBoxPreviewTool/Classes/*'
  s.resource         = 'SandBoxPreviewTool/Assets/*.bundle'
  s.frameworks = 'UIKit'
    
  # s.resource_bundles = {
  #   'SandBoxPreviewTool' => ['SandBoxPreviewTool/Assets/*.png']
  # }
  # s.public_header_files = 'Pod/Classes/*.h'
  
end
