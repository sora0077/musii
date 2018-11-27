# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

plugin 'cocoapods-keys', {
  :project => "müsii",
  :keys => [
    "GithubClientId",
    "GithubClientSecret"
  ]
}

use_modular_headers!

target 'Utility' do
  # Pods for Utility
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'FoundationSupport', :git => 'https://github.com/sora0077/FoundationSupport.git'

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
      pod 'DeepLinkKit'
      pod 'Firebase/Core'
      pod 'Firebase/Auth'
      pod 'Firebase/RemoteConfig'

      target 'ApplicationService' do
        inherit! :search_paths

        pod 'ReactorKit'
        pod 'RxCocoa'
        pod 'UIKitSupport', :git => 'https://github.com/sora0077/FoundationSupport.git'
        pod 'Constraint', :git => 'https://github.com/sora0077/Constraint.git'

        target 'App' do
          inherit! :search_paths

          # Pods for App
          pod 'SwiftLint'

          begin
            script = <<~EOS
            "${PODS_ROOT}/SwiftLint/swiftlint" autocorrect
            "${PODS_ROOT}/SwiftLint/swiftlint"
            EOS

            script_phase :name => 'Run SwiftLint', :script => script, :execution_position => :before_compile
          end

          begin
            script = <<~EOS
            "${PODS_ROOT}/Fabric/run"
            EOS

            script_phase :name => 'Run Fabric', :script => script, :input_files => ['$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)']
          end

          target 'AppTests' do
            inherit! :search_paths
            # Pods for testing
          end

          target 'AppUITests' do
            inherit! :search_paths
            # Pods for testing
          end
        end


        target 'ApplicationServiceTests' do
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

post_install do |installer|
  installer.aggregate_targets.each do |target|
    target.xcconfigs.each do |name, file|
      file.other_linker_flags[:simple] << '-all_load'

      xcconfig_path = target.xcconfig_path(name)
      file.save_as(xcconfig_path)
    end
  end
end
