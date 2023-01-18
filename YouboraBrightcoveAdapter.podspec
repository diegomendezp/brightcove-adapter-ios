Pod::Spec.new do |s|

  s.name         = 'YouboraBrightcoveAdapter'
  s.version      = '6.6.0'

  # Metadata
  s.summary      = 'Adapter to use YouboraLib on Brightcove'

  s.description  = '<<-DESC
                      YouboraBrightcoveAdapter is an adapter used 
                      for Brightcove.
                     DESC'

  s.homepage     = 'http://developer.nicepeopleatwork.com/'

  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }

  s.author             = { 'Nice People at Work' => 'support@nicepeopleatwork.com' }

  # Platforms
  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '11.0'
 
  # Platforms
  s.swift_version = '4.0', '4.1', '4.2', '4.3', '5.0', '5.1'


  # Source Location
  s.source       = { :git => 'https://bitbucket.org/npaw/brightcove-adapter-ios.git', :tag => s.version }

  # Source files
  s.source_files  = 'YouboraBrightcoveAdapter/**/*.{h,m}'
  s.public_header_files = 'YouboraBrightcoveAdapter/**/*.h'

  # Project settings
  s.requires_arc = true
  s.pod_target_xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) YOUBORAADAPTER_VERSION=' + s.version.to_s,
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'EXCLUDED_ARCHS[sdk=appletvsimulator*]' => 'arm64',
  }

  # Dependency
  s.dependency 'YouboraLib', '~> 6.5'
  s.dependency 'Brightcove-Player-Core', '~> 6.7'
  s.dependency 'Brightcove-Player-IMA', '~> 6.7'

end
