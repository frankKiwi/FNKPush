

Pod::Spec.new do |spec|

  spec.name         = "FNKPush"
  spec.version      = "0.0.2"
  spec.summary      = "集成极光推送.需要用的在.m修改"

 
  spec.description  = <<-DESC
                         https://github.com/frankKiwi/FNKPush.git
                   DESC

  spec.homepage     = "https://github.com/frankKiwi/FNKPush.git"
  
  spec.license      = "MIT"
  
  spec.author             = { "fanrenFRank" => "1778907544@qq.com" }
  
   spec.platform     = :ios, "8.0"

  spec.source       = { :git => "https://github.com/frankKiwi/FNKPush.git", :tag => "#{spec.version}" }
  
  spec.source_files  = "DreamPush/**/*.{h,m}"

  spec.frameworks = "UIKit", "Foundation"
    
   spec.requires_arc = true


  spec.dependency "JPush", "~> 3.0.6"

end
