//
//  YBGenericAdsAdapter.m
//  YouboraBrightcoveAdapter
//
//  Created by Enrique Alfonso Burillo on 25/08/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBGenericAdsAdapter.h"

// Constants
#define MACRO_NAME(f) #f
#define MACRO_VALUE(f) MACRO_NAME(f)

#define PLUGIN_VERSION_DEF MACRO_VALUE(YOUBORAADAPTER_VERSION)
#define PLUGIN_NAME_DEF "Brightcove-Ads"

#if TARGET_OS_TV==1
#define PLUGIN_PLATFORM_DEF "tvOS"
#else
#define PLUGIN_PLATFORM_DEF "iOS"
#endif

#define PLUGIN_NAME @PLUGIN_NAME_DEF "-" PLUGIN_PLATFORM_DEF
#define PLUGIN_VERSION @PLUGIN_VERSION_DEF "-" PLUGIN_NAME_DEF "-" PLUGIN_PLATFORM_DEF

@implementation YBGenericAdsAdapter

- (void)registerListeners {
    [super registerListeners];
    
    [self.player addSessionConsumer:self];
}

- (void) unregisterListeners {
    [super unregisterListeners];
    
    [self.player removeSessionConsumer:self];
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didEnterAd:(BCOVAd *)ad {
    [self fireStart];
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didExitAd:(BCOVAd *)ad {
    [self fireStop];
}

- (NSString *)getPlayerName {
    return PLUGIN_NAME;
}

- (NSString *)getPlayerVersion {
    return @PLUGIN_NAME_DEF;
}

- (NSString *)getVersion {
    return PLUGIN_VERSION;
}

@end
