# Uncomment the next line to define a global platform for your project

workspace 'AppStoreConnect.xcworkspace'

target 'AppStoreConnect' do
  platform :macos, '12.0'
  project 'AppStoreConnect/AppStoreConnect.xcodeproj'
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks! :linkage => :static
  inhibit_all_warnings!
  # Pods for HTMLTextAttributes
  pod 'SwiftJWT'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['OTHER_CFLAGS'] = "-Wno-deprecated"
      config.build_settings['DEAD_CODE_STRIPPING'] = "YES"
      config.build_settings.delete 'ARCHS'
#      config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
#      config.build_settings.delete 'ARCHS'
#      config.build_settings['ARCHS[sdk=iphonesimulator*]'] =  `uname -m`
#      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
