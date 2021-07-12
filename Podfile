# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Ping' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!
  # Pods for Ping
     pod 'JTCalendar', '~> 2.1'
     pod "CAPopUpViewController"
     pod 'AFNetworking', '~> 2.0’
     pod 'FVCustomAlertView', '~> 0.3'
     pod 'SDWebImage', '~>3.8'
     pod 'GoogleMaps'
     pod 'GooglePlaces'
     pod 'GooglePlacePicker'
     pod 'SWTableViewCell', '~> 0.3'
     pod 'Collection'
     pod 'EasyDate', '~> 0.9'
     pod 'UIColor-HexString'
     pod 'Masonry'
     pod 'GoogleAPIClientForREST/Calendar', '~> 1.2.1'
     pod 'GoogleSignIn', '~> 4.1.1'
     pod 'TNRadioButtonGroup'
     pod 'IQKeyboardManager'
     pod 'ZMJTipView'
     pod 'Fabric'
     pod 'Crashlytics'
   

end

##To fix the masonry preprocessor definition
#post_install do |installer|
#    installer.pods_project.targets.each do |target|
#        target.build_configurations.each do |config|
#            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
#            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'MAS_SHORTHAND=1'
#        end
#    end
#end

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-Ping/Pods-Ping-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'MAS_SHORTHAND=1'
        end
    end
    
end
