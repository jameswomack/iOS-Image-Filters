#
# Be sure to run `pod lib lint ImageFilters.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ImageFilters"
  s.version          = "0.1.0"
  s.summary          = "High-level image/photo filtering on iOS & Mac"
  s.homepage         = "https://github.com/jameswomack/iOS-Image-Filters"
  s.license          = 'MIT'
  s.author           = { "James Womack" => "jwomack@netflix.com" }
  s.source           = { :git => "https://github.com/jameswomack/iOS-Image-Filters.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/james_womack'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'ImageFilters/*.[hm]'
  s.public_header_files = 'ImageFilters/*.h'

  s.resources = 'ImageFilters/*.png'

  s.frameworks = 'UIKit', 'Accelerate', 'CoreImage'
end
