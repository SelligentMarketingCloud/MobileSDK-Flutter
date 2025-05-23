#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutterselligent.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutterselligent'
  s.authors          = "Marigold Engage <mobile@selligent.com>"
  s.version          = '1.0.1'
  s.summary          = 'Flutter wrapper for the Marigold Engage Android and iOS SDKs'
  s.description      = 'Flutter wrapper for the Marigold Engage Android and iOS SDKs'
  s.homepage         = 'https://github.com/SelligentMarketingCloud/MobileSDK-Flutter#readme'
  s.license          = "MIT"
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.dependency "FlutterSelligent", "1.0.1"
end
