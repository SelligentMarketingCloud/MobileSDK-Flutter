Pod::Spec.new do |s|
  s.name                = "FlutterSelligent"
  s.authors             = "Marigold Engage <mobile@selligent.com>"
  s.version             = "0.1.11"
  s.summary             = "Flutter wrapper for the Marigold Engage Android and iOS SDKs"
  s.description         = "Flutter wrapper for the Marigold Engage Android and iOS SDKs"
  s.homepage            = "https://github.com/SelligentMarketingCloud/MobileSDK-Flutter#readme"
  s.license             = "MIT"
  s.platform            = :ios, "12.0"
  s.source              = { :git => "https://github.com/SelligentMarketingCloud/MobileSDK-Flutter.git", :tag => "v" + s.version.to_s }
  s.swift_version       = "5.0"

  s.vendored_frameworks = "ios/FlutterSelligentMobileSDK.xcframework"

  s.dependency "SelligentMobileSDK/Framework", "3.8.5"
end