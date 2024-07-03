# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

    target 'iTitaLimo' do
    use_frameworks!
  
  # Pods for iTitaLimo

    pod 'Alamofire'
    pod 'AlamofireObjectMapper'
    pod 'Toast-Swift', '~> 5.0.0'
    pod 'SignaturePad', '~> 1.0.3'
    pod 'SDWebImage', :modular_headers => true
    
    pod 'FirebaseCoreInternal'
    pod 'Firebase'
    pod 'GoogleUtilities'
    pod 'FirebaseCore'
    pod 'FirebaseMessaging'
    pod 'MultilineTextField'
    
    
    post_install do |installer|
        installer.generated_projects.each do |project|
            project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                end
            end
        end
    end

#    pod 'FirebaseCoreInternal', :modular_headers => true
#    pod 'Firebase', :modular_headers => true
#    pod 'GoogleUtilities', :modular_headers => true
#    pod 'FirebaseCore', :modular_headers => true
#    pod 'FirebaseMessaging', :modular_headers => true
    

    
    
    ## NOT USED ########################
    
#    pod 'Firebase', :modular_headers => true
#    pod 'FirebaseCoreInternal', :modular_headers => true
#    pod 'FirebaseCore', :modular_headers => true

   
    
end


  
