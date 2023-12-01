# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SAN SALES' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SAN SALES
  pod 'Alamofire'
  pod 'FSCalendar'
  pod 'Parchment' # Add this line to include the Parchment pod
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
            end
        end
    end
end

