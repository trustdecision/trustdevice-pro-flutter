#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint trustdevice_pro_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'trustdevice_pro_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  #s.vendored_frameworks = 'Frameworks/TDMobRisk.framework', 'Frameworks/TDCorePlugin.framework'

  s.dependency 'Flutter'
  s.dependency 'TrustDecisionPro', '4.2.6'
  s.dependency 'TrustDecisionCaptcha', '2.1.8.3'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
