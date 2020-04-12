Pod::Spec.new do |s|
  s.name             = "SettingsKit"
  s.version          = "0.1.0"
  s.summary          = <<-SUMMARY
                       SettingsKit provides an elegant wrapper for iOS app settings.
                       SUMMARY
  s.description      = <<-DESC
                       SettingsKit makes working with app settings easier & safer
                       by providing a tidy API for retrieving, updating, and
                       observing preference items in your app's Settings bundle.
                       DESC
  s.homepage         = "https://github.com/dtrenz/SettingsKit"
  s.license          = "Apache 2.0"
  s.author           = { "Dan Trenz" => "dtrenz@gmail.com" }
  s.source           = { :git => "https://github.com/dtrenz/SettingsKit.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/dtrenz"

  s.requires_arc     = true
  #s.source_files     = [ "Sources/**/*", "cli/**/*", "build" ]
  s.preserve_paths   = [ "cli/**/*", "build" ]
  s.source_files     = [ "Sources/**/*" ]
  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '11.0'
  s.tvos.deployment_target = '11.0'
end
