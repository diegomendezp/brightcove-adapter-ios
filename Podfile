# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

workspace 'YouboraBrightcoveAdapter.xcworkspace'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/brightcove/BrightcoveSpecs.git'

def common_lib
  pod 'YouboraLib'
end

def common_lib_examples
  common_lib
  pod 'YouboraConfigUtils'
end

target 'YouboraBrightcoveAdapter' do
    project 'YouboraBrightcoveAdapter.xcodeproj'
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    use_frameworks!
    
    # Pods for YouboraBrightcoveAdapter
    common_lib
    #pod 'Brightcove-Player-Core/dynamic'
    #pod 'Brightcove-Player-SDK-IMA'
    #pod 'Brightcove-Player-IMA', '~> 6.7'
    #pod 'Brightcove-Player-OnceUX/dynamic'
end

target 'YouboraBrightcoveAdapter tvOS' do
    project 'YouboraBrightcoveAdapter.xcodeproj'
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    use_frameworks!
    platform :tvos, '11.0'
    
    # Pods for YouboraBrightcoveAdapter
    common_lib
    #pod 'Brightcove-Player-Core'
end

target 'BrightcoveAdapterExample' do
    project 'Example/BrightcoveAdapterExample.xcodeproj'
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    use_frameworks! 
    
    
    # Pods for BrightcoveAdapterExample
    #pod 'Brightcove-Player-SDK'
    #pod 'Brightcove-Player-IMA', '~> 6.7'
    common_lib_examples
   
end

target 'BasicSSAIPlayer' do
  project 'BasicSSAIPlayer/BasicSSAIPlayer.xcodeproj'
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!
  
  # Pods for BasicSSAIPlayer
  #pod 'Brightcove-Player-SSAI'
  #pod 'Brightcove-Player-IMA'
  common_lib_examples
end

target 'BasicSSAIPlayer tvOS' do
  project 'BasicSSAItvOSPlayer/BasicSSAIPlayer tvOS.xcodeproj'
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!
  platform :tvos, '11.0'
  
  # Pods for BasicSSAIPlayer tvOS
 # pod 'Brightcove-Player-SSAI'
  common_lib_examples
end

target 'BasicOUXPlayer' do
    project 'Example/ONCEOUX/BasicOUXPlayer.xcodeproj'
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    use_frameworks!
    
    # Pods for BasicOUXPlayer
    common_lib_examples
    #pod 'Brightcove-Player-SDK'
    # pod 'Brightcove-Player-OnceUX'
end
