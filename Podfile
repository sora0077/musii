# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

use_modular_headers!

target 'Utility' do
  # Pods for Utility

  target 'Domain' do
    inherit! :search_paths

    # Pods for Domain
    pod 'Tagged'
    pod 'RxSwift'

    target 'Infrastructure' do
      inherit! :search_paths

      # Pods for Infrastructure
      pod 'Alamofire'
      pod 'RealmSwift'

      target 'App' do
        inherit! :search_paths

        # Pods for App
        pod 'ReactorKit'
        pod 'SwiftLint'

        script_phase :name => 'Run SwiftLint',
                     :script => '"${PODS_ROOT}/SwiftLint/swiftlint" autocorrect',
                     :execution_position => :before_compile

        target 'AppTests' do
          inherit! :search_paths
          # Pods for testing
        end

        target 'AppUITests' do
          inherit! :search_paths
          # Pods for testing
        end
      end

      target 'InfrastructureTests' do
        inherit! :search_paths
        # Pods for testing
      end
    end

    target 'DomainTests' do
      inherit! :search_paths
      # Pods for testing
    end
  end

  target 'UtilityTests' do
    inherit! :search_paths
    # Pods for testing
  end
end
