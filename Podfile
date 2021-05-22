# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'
# Workspace
workspace 'mockbank'
def shared_common_pod
    pod 'IQKeyboardManagerSwift', '6.5.5'
end

    
target 'MainApp' do
  project 'MainApp/MainApp.project'
  shared_common_pod
  use_frameworks!

  # Pods for MainApp
  target 'MainAppTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'AppNavigations' do
  project 'Navigation/AppNavigations/AppNavigations.project'
  shared_common_pod
  use_frameworks!

  # Pods for AppNavigations
  target 'AppNavigationsTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'Splash' do
  project 'Features/Splash/Splash.project'
  shared_common_pod
  use_frameworks!

  # Pods for Splash
  target 'SplashTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'Authentication' do
  project 'Features/Authentication/Authentication.project'
  shared_common_pod
  use_frameworks!

  # Pods for Authentication
  target 'AuthenticationTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'Payment' do
  project 'Features/Payment/Payment.project'
  shared_common_pod
  use_frameworks!

  # Pods for Payment
  target 'PaymentTests' do
    inherit! :search_paths
    # Pods for testing
  end
end


target 'Topup' do
  project 'Features/Topup/Topup.project'
  shared_common_pod
  use_frameworks!

  # Pods for Topup
  target 'TopupTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'Dashboard' do
  project 'Features/Dashboard/Dashboard.project'
  shared_common_pod
  use_frameworks!

  # Pods for Dashboard
  target 'DashboardTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

