require 'xcodeproj'

project = Xcodeproj::Project.open('Runner.xcodeproj')

# Modifier le target Runner
project.targets.each do |target|
  if target.name == 'Runner' || target.name.start_with?('Pods-Runner')
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end

project.save
puts "✅ iOS Deployment Target mis à jour vers 13.0 pour tous les targets"
