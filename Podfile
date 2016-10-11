source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

def pods

    pod 'IQKeyboardManagerSwift'
    pod 'AlamofireObjectMapper'
    pod 'RealmSwift'
    pod 'SwiftyJSON', :git=> 'https://github.com/SwiftyJSON/SwiftyJSON.git'

	
end

target 'MyBaby' do
    pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |configuration|
      configuration.build_settings['SWIFT_VERSION'] = "3.0"
    end
  end
end