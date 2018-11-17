# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

# install(:App, {
#   :App => {
#     :pods => lambda {
#
#     },
#     :deps => [:Infrastructure]
#   },
#   :Infrastructure => {
#     :pods => lambda {
#
#     },
#     :deps => [:Domain, :AppleMusicKit]
#   },
#   :Domain => {
#     :pods => lambda {
#
#     },
#     :deps => [:Utility]
#   },
#   :AppleMusicKit => {
#     :pods => lambda {
#
#     },
#     :deps => []
#   },
#   :Utility => {
#     :pods => lambda {
#
#     },
#     :deps => []
#   }
# })


target 'Utility' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # Pods for Utility

  target 'Domain' do
    inherit! :search_paths
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    # Pods for Domain


    target 'Infrastructure' do
      inherit! :search_paths
      # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
      use_frameworks!

      # Pods for Infrastructure
      pod 'Alamofire'
      pod 'RxSwift'

      target 'App' do
        inherit! :search_paths
        # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
        use_frameworks!

        # Pods for App
        pod 'ReactorKit'

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
