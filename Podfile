# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

# Basic
def basic_pods
  pod 'Alamofire'       
  pod 'ColorCompatibility'
  # pod 'SwiftyBeaver'
  pod 'RxSwift'           
  pod 'RxCocoa'            
  pod 'RxSwiftExt'        
  pod 'RxDataSources'   
end

# Testing
def test_pods
  pod 'RxBlocking'       
  pod 'RxTest'            
end

target 'MVVM-C' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

basic_pods

  # Pods for MVVM-C

  target 'MVVM-CTests' do
    inherit! :search_paths
    # Pods for testing
test_pods
  end

  target 'MVVM-CUITests' do
    # Pods for testing
  end

# Enable RxSwift.Resources for debugging
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name == 'RxSwift'
        target.build_configurations.each do |config|
          if config.name == 'Debug'
            config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
          end
        end
      end
    end
  end

end
