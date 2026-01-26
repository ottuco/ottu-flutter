Pod::Spec.new do |s|
  s.name             = 'ottu_flutter_checkout'
  s.version          = '0.0.1' # Sync this with your pubspec.yaml version
  s.summary          = 'A Flutter checkout integration for Ottu.'
  s.description      = <<-DESC
A Flutter plugin for the Ottu Checkout SDK integration on iOS.
                       DESC
  s.homepage         = 'https://github.com/ottuco/ottu-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author           = { 'Ottu' => 'support@ottu.com' }
  s.source           = { :path => '.' }

  s.ios.deployment_target = '14.0'
  s.swift_version = '5.5'

  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'

  s.dependency 'Flutter'
  s.dependency 'ottu_checkout_sdk', '~> 2.1.10'
  s.dependency 'Sentry', '~> 8.46.0'

  # Resources (Privacy and Assets)
  s.resource_bundles = {
    'ottu_flutter_checkout_privacy' => ['Classes/PrivacyInfo.xcprivacy'],
    'ottu_flutter_checkout_resources' => ['Resources/**/*']
  }

  # C Settings / Header Search Paths
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'HEADER_SEARCH_PATHS' => '$(PODS_TARGET_SRCROOT)/Classes/include/ottu_flutter_checkout'
  }
end