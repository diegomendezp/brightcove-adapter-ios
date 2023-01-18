//
//  YBGenericAdsAdapter.h
//  YouboraBrightcoveAdapter
//
//  Created by Enrique Alfonso Burillo on 25/08/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BrightcovePlayerSDK/BrightcovePlayerSDK.h>

@import YouboraLib;
typedef id<BCOVPlaybackController> BCovePlayer;

@interface YBGenericAdsAdapter : YBPlayerAdapter<BCOVPlaybackSessionConsumer>

@end
