
Pod::Spec.new do |s|

s.name        = "LGFTransition"
s.version     = "0.1.7"
s.summary     = "LGFTransition"
s.homepage    = "https://github.com/aiononhiii/LGFTransition"
s.license     = { :type => 'MIT', :file => 'LICENSE' }
s.authors     = { "aiononhiii" => "452354033@qq.com" }
s.requires_arc = true
s.platform     = :ios
s.platform     = :ios, "8.0"
s.source   = { :git => "https://github.com/aiononhiii/LGFTransition.git", :tag => s.version }
s.framework  = "UIKit"
s.source_files = "LGFTransition/**/*.{h,m}"
s.resource_bundles = {
'LGFTransition' => ['LGFTransition/**/*.{xib,storyboard}']
}
s.dependency 'SDWebImage', '4.4.1'
end
