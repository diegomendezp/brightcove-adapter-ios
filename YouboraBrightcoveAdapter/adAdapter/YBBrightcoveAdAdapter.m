//
//  YBOnceUXAdsAdapter.m
//  YouboraBrightcoveAdapter
//
//  Created by Enrique Alfonso Burillo on 31/07/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBBrightcoveAdAdapter.h"
#import <TargetConditionals.h>

@import YouboraLib;

// Constants
#define MACRO_NAME(f) #f
#define MACRO_VALUE(f) MACRO_NAME(f)

#define PLUGIN_VERSION_DEF MACRO_VALUE(YOUBORAADAPTER_VERSION)
#define PLUGIN_NAME_DEF "Brightcove-ONCEUX"

#if TARGET_OS_TV==1
#define PLUGIN_PLATFORM_DEF "tvOS"
#else
#define PLUGIN_PLATFORM_DEF "iOS"
#endif

#define PLUGIN_NAME @PLUGIN_NAME_DEF "-" PLUGIN_PLATFORM_DEF
#define PLUGIN_VERSION @PLUGIN_VERSION_DEF "-" PLUGIN_NAME_DEF "-" PLUGIN_PLATFORM_DEF

@interface YBBrightcoveAdAdapter()

@property (nonatomic, weak) BCOVAd *currentAd;
@property (nonatomic, weak) BCOVAdSequence *currentAdSequence;
@property (nonatomic, assign) double adPlayhead;
@property NSNumber *lastReportedBitrate;
@property int lastQuartileSent;

@end

@implementation YBBrightcoveAdAdapter

- (void) registerListeners {
    [super registerListeners];
    self.adPlayhead = -1;
    
    [self.player addSessionConsumer:self];
}

- (void) unregisterListeners {
    [self.player removeSessionConsumer:self];
    [super unregisterListeners];
    
    self.currentAd = nil;
}

#pragma mark - BCOVPlaybackSessionAdsConsumer methods
- (void)playbackSession:(id<BCOVPlaybackSession>)session didEnterAdSequence:(BCOVAdSequence *)adSequence {
    self.currentAdSequence = adSequence;
    [self fireAdBreakStart];
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didExitAdSequence:(BCOVAdSequence *)adSequence {
     self.currentAdSequence = nil;
    [self fireAdBreakStop];
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didEnterAd:(BCOVAd *)ad {
    [YBLog debug:@"didEnterAd"];
    self.lastQuartileSent = 0;
    self.currentAd = ad;
    [self fireStart];
    [self fireJoin];
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didExitAd:(BCOVAd *)ad {
    [YBLog debug:@"didExitAd"];
    [self fireStop];
    self.currentAd = nil;
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session ad:(BCOVAd *)ad didProgressTo:(NSTimeInterval)progress {
    if (progress >= 0 && progress < INFINITY && self.flags.started) {
        self.adPlayhead = progress;
        
        NSNumber *duration = @(CMTimeGetSeconds(ad.duration));
        
        [self checkQuartile:(progress*100)/[duration doubleValue]];
    }
}

-(void)checkQuartile:(float)progress {
    if (progress > 25 && self.lastQuartileSent < 1) {
        [self fireQuartile: ++self.lastQuartileSent];
        return;
    }
    
    if (progress > 50 && self.lastQuartileSent < 2) {
        [self fireQuartile: ++self.lastQuartileSent];
        return;
    }
    
    if (progress > 75 && self.lastQuartileSent < 3) {
        [self fireQuartile: ++self.lastQuartileSent];
        return;
    }
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didPauseAd:(BCOVAd *)ad {
    [YBLog debug:@"didPauseAd"];
    [self firePause];
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didResumeAd:(BCOVAd *)ad {
    [YBLog debug:@"didResumeAd"];
    [self fireResume];
}

#pragma mark - Private methods
- (NSNumber *) getDuration {
    if (self.currentAd != nil) {
        return @(CMTimeGetSeconds(self.currentAd.duration));
    }
    return [super getDuration];
}

- (NSString *) getTitle {
    if (self.currentAd != nil) {
        return self.currentAd.title;
    }
    return [super getTitle];
}

- (NSNumber *) getPlayhead {
    if (self.adPlayhead > 0) {
        return @(self.adPlayhead);
    }
    return [super getPlayhead];
}

- (YBAdPosition) getPosition {
    if (self.plugin != nil && self.plugin.adapter != nil && !self.plugin.adapter.flags.joined) {
        return YBAdPositionPre;
    }
    return YBAdPositionMid;
}

- (NSString *)getAdProvider {
    return nil;
}

- (NSString *)getResource {
    return nil;
}

- (NSNumber *)getGivenAds {
    if (self.currentAdSequence != nil) {
        return [NSNumber numberWithInteger:self.currentAdSequence.ads.count];
    }
    
    return [super getGivenAds];
}

- (void) fireStop:(NSDictionary<NSString *,NSString *> *)params {
    [super fireStop:params];
    self.adPlayhead = 0;
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
