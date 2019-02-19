source "https://rubygems.org"

gem "fastlane", path: "/Users/felixkrause/Developer/fastlane"
gem "cocoapods"
gem "pry"
gem "xcode-install"

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
