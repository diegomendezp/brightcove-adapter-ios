//
//  YBBrightcoveAdapter.m
//  YouboraBrightcoveAdapter
//
//  Created by Enrique Alfonso Burillo on 23/08/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBBrightcoveAdapter.h"
#import <TargetConditionals.h>

// Constants
#define MACRO_NAME(f) #f
#define MACRO_VALUE(f) MACRO_NAME(f)

#define PLUGIN_VERSION_DEF MACRO_VALUE(YOUBORAADAPTER_VERSION)
#define PLUGIN_NAME_DEF "Brightcove"

#if TARGET_OS_TV==1
    #define PLUGIN_PLATFORM_DEF "tvOS"
#else
    #define PLUGIN_PLATFORM_DEF "iOS"
#endif

#define PLUGIN_NAME @PLUGIN_NAME_DEF "-" PLUGIN_PLATFORM_DEF
#define PLUGIN_VERSION @PLUGIN_VERSION_DEF "-" PLUGIN_NAME_DEF "-" PLUGIN_PLATFORM_DEF

@interface YBBrightcoveAdapter()
#ifndef YOUBORA_BCOVE4_LEGACY
    @property (nonatomic, weak) id<BCOVPlaybackSession> currentSession;
#endif
    @property (nonatomic, assign) double duration;
    @property (nonatomic, assign) double lastReportedProgress;
    @property (nonatomic, assign) NSNumber* lastReportedBitrate;

    @property BOOL justBuffered;
    @property BOOL onBackground;
@end


@implementation YBBrightcoveAdapter

- (void)registerListeners {
    [super registerListeners];
    
    [self resetValues];
    
    [self monitorPlayheadWithBuffers:NO seeks:YES andInterval:800];
    
    [self.monitor stop];
    
    self.justBuffered = NO;
    self.onBackground = NO;
    
    //Needed to prevent from starting again when going to background
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventListenerDidReceivetoBack:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventListenerDidReceiveToFore:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [self.player addSessionConsumer:self];
}
    
- (void) unregisterListeners {
    [super unregisterListeners];
    
    [self.player removeSessionConsumer:self];
    
    self.currentSession = nil;
    self.lastReportedProgress = 0;
}

-(void)appWillResign:(NSNotification*)notification {
    
}

#pragma mark - BCOVPlaybackSessionBasicConsumer methods
- (void)didAdvanceToPlaybackSession:(id<BCOVPlaybackSession>)session {
    // Start detected
    [YBLog debug:@"didAdvanceToPlaybackSession"];
    self.currentSession = session;
    
    //[self fireStart];
}
    
- (void)playbackSession:(id<BCOVPlaybackSession>)session didChangeDuration:(NSTimeInterval)duration {
    self.duration = duration;
    [YBLog debug:@"didChangeDuration: %f", duration];
}
    
- (void)playbackSession:(id<BCOVPlaybackSession>)session didChangeExternalPlaybackActive:(BOOL)externalPlaybackActive {
    //[YBLog debug:@"didChangeExternalPlaybackActive"];
}
    
- (void)playbackSession:(id<BCOVPlaybackSession>)session didPassCuePoints:(NSDictionary *)cuePointInfo {
    //[YBLog debug:@"didPassCuePoints"];
}
    
- (void)playbackSession:(id<BCOVPlaybackSession>)session didProgressTo:(NSTimeInterval)progress {
    
    NSTimeInterval progressAbsolute = ABS(progress);
    
    if (progressAbsolute > 0.1 && progressAbsolute < INFINITY) {

        self.lastReportedProgress = progress;
        
        if (!self.flags.joined && self.onBackground == NO) {
            [YBLog debug:@"Join detected"];
            if (!self.flags.started) {
                [self fireStart];
            }
            [self fireJoin];
        }
    }
}
    
- (void)playbackSession:(id<BCOVPlaybackSession>)session didReceiveLifecycleEvent:(BCOVPlaybackSessionLifecycleEvent *)lifecycleEvent {
    [YBLog debug:@"didReceiveLifecycleEvent: %@", lifecycleEvent.eventType];
    
    if (lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventEnd) {
        [self fireStop];
        [self resetValues];
    } else if (lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventPlay) {
        //This "delay" is made in order to let playheadmonitor do it's work. DO NOT REMOVE
        [self fireResume];
    } else if (lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventPause) {
        //This "delay" is made in order to let playheadmonitor do it's work. DO NOT REMOVE
        [self firePause];
    } else if (lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventPlaybackBufferEmpty) {
        if (!self.flags.joined && self.onBackground == NO) {
            [self fireStart];
        }
    } else if (lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventPlaybackStalled) {
        [self fireBufferBegin];
    } else if (lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventPlaybackRecovered) {
        [self fireBufferEnd];
        self.justBuffered = TRUE;
    } else if (lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventPlaybackLikelyToKeepUp) {
        self.justBuffered = FALSE;
    } else if (lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventFail) {
        NSError *error = lifecycleEvent.properties[kBCOVPlaybackSessionEventKeyError];
        NSString * code = @"9999";
        if (error.code) {
            code = [NSString stringWithFormat:@"%ld", (long)error.code];
        }
        if ([code isEqualToString:kBCOVPlaybackSessionLifecycleEventFailedToPlayToEndTime]) {
            [self fireFatalErrorWithMessage:error.localizedDescription code:[NSString stringWithFormat:@"%ld", (long)error.code] andMetadata:nil];
            [self resetValues];
        } else {
            [self fireErrorWithMessage:error.localizedDescription code:code andMetadata:nil];
            if([code isEqualToString:@"69401"] || [code isEqualToString:@"-1200"]) {
                [self fireStop];
                [self resetValues];
            }
        }
    } else if (lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventFailedToPlayToEndTime) {
        NSError *error = lifecycleEvent.properties[@"error"];
        if (error != nil) {
            [self fireFatalErrorWithMessage:error.localizedDescription code:[NSString stringWithFormat:@"%ld", (long)error.code] andMetadata:nil];
            [self resetValues];
        }
    } else if (lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventError) {
        NSError *error = lifecycleEvent.properties[kBCOVPlaybackSessionEventKeyError];
        [self fireErrorWithMessage:error.localizedDescription code:[NSString stringWithFormat:@"%ld", (long)error.code] andMetadata:nil];
    }
}
    
- (void)playbackSession:(id<BCOVPlaybackSession>)session didChangeSeekableRanges:(NSArray *)seekableRanges {
    //[YBLog debug:@"didChangeSeekableRanges"];
}
    
- (void) resetValues {
    self.duration = [super getDuration].doubleValue;
    self.lastReportedProgress = 0;
}
    
#pragma mark - BCOVPlaybackSessionAdsConsumer methods
#ifndef YOUBORA_BCOVE4
    /**
     * This is the no-adnalyzer fallback logic. If no adnalyzer is set, at least the
     * plugin will ignore the ads so they don't compute for joinTime
     */
- (void)playbackSession:(id<BCOVPlaybackSession>)session didEnterAd:(BCOVAd *)ad {
    [YBLog debug:@"didEnterAd"];
}
    
- (void)playbackSession:(id<BCOVPlaybackSession>)session didExitAd:(BCOVAd *)ad {
    [YBLog debug:@"didExitAd"];
}
#endif
    
#pragma mark - Overridden get methods
- (NSNumber *)getPlayhead {
    NSNumber * playhead = [super getPlayhead];
    @try {
        if (self.lastReportedProgress > 0){
            playhead = @(self.lastReportedProgress);
        }
    } @catch (NSException *exception) {
        [YBLog logException:exception];
    } @finally {
        return playhead;
    }
}
    
- (NSNumber *) getDuration {
    if (self.duration != INFINITY) {
        return @(self.duration);
    } else {
        return [super getDuration];
    }
}
    
- (NSNumber *)getBitrate {
    NSNumber * bitrate = bitrate == nil ? [NSNumber numberWithInt:-1] : self.lastReportedBitrate;
    @try {
        if (self.currentSession != nil) {
            AVPlayerItemAccessLogEvent * event = nil;
            
            NSArray<AVPlayerItemAccessLogEvent *> * events = self.currentSession.player.currentItem.accessLog.events;
            if (events != nil) {
                // Sometimes the event's values are zero, so iterate backwards and pick the first
                // non-zero event
                for (long i = events.count - 1; i >= 0; i--) {
                    AVPlayerItemAccessLogEvent * ev = [events objectAtIndex:i];
                    if (ev.numberOfBytesTransferred != 0 && ev.segmentsDownloadedDuration != 0) {
                        event = ev;
                        break;
                    }
                }
            }
            if (event != nil) {
                bitrate = @(event.numberOfBytesTransferred * 8 / event.segmentsDownloadedDuration);
            }
        }
    } @catch (NSException *exception) {
        [YBLog logException:exception];
    } @finally {
        self.lastReportedBitrate = bitrate;
        return bitrate;
    }
}
    
- (NSNumber *)getThroughput {
    
    NSNumber * throughput = [super getThroughput];
    @try {
        if (self.currentSession != nil) {
            AVPlayerItemAccessLogEvent * event = nil;
            
            NSArray<AVPlayerItemAccessLogEvent *> * events = self.currentSession.player.currentItem.accessLog.events;
            if (events != nil) {
                // Sometimes the event's values are zero, so iterate backwards and pick the first
                // non-zero event
                for (long i = events.count - 1; i >= 0; i--) {
                    AVPlayerItemAccessLogEvent * ev = [events objectAtIndex:i];
                    if (ev.observedBitrate != 0 && !isnan(ev.observedBitrate)) {
                        event = ev;
                        break;
                    }
                }
            }
            if (event != nil) {
                throughput = @(event.observedBitrate);
            }
        }
    } @catch (NSException *exception) {
        [YBLog logException:exception];
    } @finally {
        return throughput;
    }
}
    
- (NSString *)getRendition {
    
    NSString * rendition = [super getRendition];
    @try {
        if (self.currentSession != nil) {
            AVPlayerItemAccessLogEvent * event = nil;
            
            NSArray<AVPlayerItemAccessLogEvent *> * events = self.currentSession.player.currentItem.accessLog.events;
            if (events != nil) {
                // Sometimes the event's values are zero, so iterate backwards and pick the first
                // non-zero event
                for (long i = events.count - 1; i >= 0; i--) {
                    AVPlayerItemAccessLogEvent * ev = [events objectAtIndex:i];
                    if (ev.indicatedBitrate != 0 && ev.numberOfBytesTransferred != 0 && ev.segmentsDownloadedDuration != 0) {
                        event = ev;
                        break;
                    }
                }
            }
            if (event != nil) {
                double bitrate = (event.numberOfBytesTransferred * 8) / event.segmentsDownloadedDuration;
                if (bitrate != event.indicatedBitrate) {
                    rendition = [YBYouboraUtils buildRenditionStringWithWidth:0 height:0 andBitrate:event.indicatedBitrate];
                }
            }
        }
    } @catch (NSException *exception) {
        [YBLog logException:exception];
    } @finally {
        return rendition;
    }
}
    
- (NSString *)getResource {
    
    if (self.currentSession) {
        return self.currentSession.source.url.absoluteString;
    } else {
        return [super getResource];
    }
}
    
- (NSString *)getTitle {
    if (self.currentSession) {
        return (NSString *) self.currentSession.video.properties[@"shortDescription"];
    } else {
        return [super getTitle];
    }
}

- (NSValue *)getIsLive {
    return self.duration == INFINITY? @YES : @NO;
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

//Just to prevent starting again if autoBackground option is enabled
- (void) eventListenerDidReceivetoBack:(NSNotification*)uselessNotification {
    self.onBackground = YES;
}

- (void) eventListenerDidReceiveToFore:(NSNotification*)uselessNotification {
    self.onBackground = NO;
}
@end
