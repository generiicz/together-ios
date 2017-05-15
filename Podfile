# Uncomment this line to define a global platform for your project
 platform :ios, '9.0'
 source 'https://github.com/CocoaPods/Specs.git'
target 'Together' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Together
  pod 'Alamofire', '~> 4.0'
  pod 'AlamofireImage', '~> 3.0'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'Locksmith'
  pod 'SwiftyUserDefaults'
  pod 'SideMenu'
  pod 'RxSwift', '~> 3.0.0-beta.1'
  pod 'RxCocoa', '~> 3.0.0-beta.1'
  pod 'JSQMessagesViewController'
  pod 'TTRangeSlider'

  target 'TogetherTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TogetherUITests' do
    inherit! :search_paths
    # Pods for testing
  end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

end
