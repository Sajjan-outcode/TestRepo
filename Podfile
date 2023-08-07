# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Upright' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Alamofire', '4.9.1', :inhibit_warnings => true
  pod 'SwiftKeychainWrapper', :inhibit_warnings => true
  # Pods for Upright

  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
 
  end

  installer.generated_projects.each do |project|
    project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
            end
        end
    end
end
