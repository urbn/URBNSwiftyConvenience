Pod::Spec.new do |s|
  s.name             = "URBNSwiftyConvenience"
  s.version          = "1.4.0"
  s.summary          = "Convenience methods for commonly used iOS frameworks"
  s.homepage         = "https://github.com/urbn/URBNSwiftyConvenience"
  s.license          = 'MIT'
  s.author           = { "URBN Mobile Team" => "mobileteam@urbanout.com" }
  s.source           = { :git => "https://github.com/urbn/URBNSwiftyConvenience.git", :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'

  s.requires_arc = true

  s.source_files = 'URBNSwiftyConvenience/Classes/**/*'
end
