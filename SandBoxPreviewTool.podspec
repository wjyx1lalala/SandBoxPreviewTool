
Pod::Spec.new do |s|

  s.name         = "SandBoxPreviewTool"
  s.version      = "1.1"
  s.summary      = "Make iOS preview sandbox in your app more easy"
  s.description  = <<-DESC
                      help you preview sandbox easy in you application with one line of code
                   DESC

  s.homepage     = "https://github.com/wjyx1lalala/SandBoxPreviewTool"
  s.screenshots  = "https://nuomiadai.oss-cn-shanghai.aliyuncs.com/localdb.jpg", "https://nuomiadai.oss-cn-shanghai.aliyuncs.com/sharedb.jpg"
  s.license      = "MIT"
  s.author       = { "nuomi" => "49238605@qq.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/wjyx1lalala/SandBoxPreviewTool.git", :tag => "v1.1" }
  s.source_files  = "SandBoxPreviewTool", "沙盒查看工具/SandBoxPreviewTool/*.{h,m}"
  s.resources = "沙盒查看工具/SandBoxPreviewTool/iconSource/*.png"
  s.frameworks = "UIKit"
  s.requires_arc = true 

end
