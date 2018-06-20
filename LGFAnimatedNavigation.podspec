
Pod::Spec.new do |s|

s.name        = "LGFPageTitle"
s.version     = "0.0.1"
s.summary     = "LGFPageTitle"
s.homepage    = "https://github.com/aiononhiii/LGFPageTitleView"
s.license     = { :type => 'MIT', :file => 'LICENSE' }
s.authors     = { "aiononhiii" => "452354033@qq.com" }

s.requires_arc = true
s.resource_bundles = {
'LGFPageTitle' => ['LGFPageTitle/*.{xib,storyboard}']
}
s.platform     = :ios
s.platform     = :ios, "8.0"
s.source   = { :git => "https://github.com/aiononhiii/LGFPageTitleView.git", :tag => s.version }
s.framework  = "UIKit"
s.source_files = "LGFPageTitle/*.{h,m}"
end
