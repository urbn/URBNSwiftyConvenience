Pod::Spec.new do |s|
  s.name             = "URBNSwiftyConvenience"
  s.version          = "0.1.0"
  s.summary          = "Convenience methods for commonly used iOS frameworks"
  s.homepage         = "https://github.com/urbn/URBNSwiftyConvenience"
  s.license          = 'MIT'
  s.author           = { "URBN Mobile Team" => "mobileteam@urbanout.com" }
  s.source           = { :git => "https://github.com/urbn/URBNSwiftyConvenience.git", :tag => s.version.to_s }

  s.platforms = { :ios => "8.0", :tvos => "9.0" }
  s.requires_arc = true

  s.source_files = 'URBNSwiftyConvenience/Classes/**/*'
end