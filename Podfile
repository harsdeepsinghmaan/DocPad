# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'DocPad' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for DocPad
  pod 'Charts'
  pod 'DropDown'
  pod 'IQKeyboardManagerSwift'
  pod 'JitsiMeetSDK', '~> 2.11'
  pod 'KDCalendar', '~> 1.6.5'
  pod 'LGSideMenuController'
  pod 'MBProgressHUD'
  pod 'NKVPhonePicker'
  pod 'ReachabilitySwift'
  pod 'SDWebImage'
  pod 'SVProgressHUD'
  pod "SwiftPhoneNumberFormatter"
  pod "UHNBGMController"
  
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_BITCODE'] = 'NO'
      end
    end
  end
  
  target 'DocPadTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'DocPadUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
end
