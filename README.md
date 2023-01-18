
# YouboraBrightcoveAdapter

A framework that will collect several video events from the Brightcove and send it to the back end

# Installation

#### CocoaPods

1. Insert into your Podfile

```bash
pod 'YouboraBrightcoveAdapter'
```

2. Execute the command
```bash
pod install
```
## How to use

## Start plugin and options

#### Swift

```swift

//Import
import YouboraLib

...

//Config Options and init plugin (do it just once for each play session)


let options = YBOptions()
options.contentResource = "http://example.com"
options.accountCode = "accountCode"
options.adResource = "http://example.com"
options.contentIsLive = NSNumber(value: false)
    
var plugin = YBPlugin(options: options)
```

#### Obj-C

```objectivec

//Import
#import <YouboraLib/YouboraLib.h>

...

// Declare the properties
@property YBPlugin *plugin;

...

//Config Options and init plugin (do it just once for each play session)

YBOptions *options = [YBOptions new];
options.offline = false;
options.contentResource = resource.resourceLink;
options.accountCode = @"powerdev";
options.adResource = self.ad?.adLink;
options.contentIsLive = [[NSNumber alloc] initWithBool: resource.isLive];
        
self.plugin = [[YBPlugin alloc] initWithOptions:self.options];
```

For more information about the options you can check [here](http://developer.nicepeopleatwork.com/apidocs/ios6/Classes/YBOptions.html)

### YBBrightcoveAdapter & YBAVPlayerAdsAdapter

#### Swift

```swift
import YouboraBrightcoveAdapter
import YouboraLib
...

//Once you have your player and plugin initialized you can set the adapter
self.plugin.adapter = YBBrightcoveAdapterSwiftTransformer.transform(from: YBBrightcoveAdapter(player: player))

...

//If you want to setup the ads adapter
self.plugin.adsAdapter = YBBrightcoveAdapterSwiftTransformer.transform(fromAdsAdapter: YBBrightcoveAdAdapter(player: player))

...

//When the ad finishes 
self.plugin.removeAdsAdapter()

...

// When the view gonna be destroyed you can force stop and clean the adapters in order to make sure you avoid retain cycles  
self.plugin.fireStop()
self.plugin.removeAdapter()
self.plugin.removeAdsAdapter()
```

#### Obj-C

```objectivec
@import YouboraLib;
@import YouboraBrightcoveAdapter;
...

//Once you have your player and plugin initialized you can set the adapter
[self.plugin setAdapter: [[YBBrightcoveAdapter alloc] initWithPlayer:player]];

...

//If you want to setup the ads adapter
[self.plugin setAdsAdapter: [[YBBrightcoveAdAdapter alloc] initWithPlayer:player]];

...

//When the ad finishes 
[self.plugin removeAdsAdapter];
...

// When the view gonna be destroyed you can force stop and clean the adapters in order to make sure you avoid retain cycles  
[self.plugin fireStop];
[self.plugin removeAdapter];
[self.plugin removeAdsAdapter];
```

## Run samples project

In order to run the examples project you should:

Execute on your root folder:

```bash
  pod install
```
