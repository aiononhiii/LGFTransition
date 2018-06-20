
Pod::Spec.new do |s|

s.name        = "LGFAnimatedNavigation"
s.version     = "0.0.3"
s.summary     = "LGFAnimatedNavigation"
s.homepage    = "https://github.com/aiononhiii/LGFAnimatedNavigation"
s.license     = { :type => 'MIT', :file => 'LICENSE' }
s.authors     = { "aiononhiii" => "452354033@qq.com" }
s.requires_arc = true
s.platform     = :ios
s.platform     = :ios, "8.0"
s.source   = { :git => "https://github.com/aiononhiii/LGFAnimatedNavigation.git", :tag => s.version }
s.framework  = "UIKit"
s.source_files = "LGFAnimatedNavigation/*.{h,m}"
end
