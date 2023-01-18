//
//  YBBrightcoveAdapterSwiftWrapper.m
//  YouboraBrightcoveAdapter
//
//  Created by Enrique Alfonso Burillo on 29/12/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBBrightcoveAdapterSwiftWrapper.h"

#import <YouboraBrightcoveAdapter/YouboraBrightcoveAdapter.h>
@import YouboraLib;

typedef id<BCOVPlaybackController> BCovePlayer;

@interface YBBrightcoveAdapterSwiftWrapper ()

@property(nonatomic,strong) NSObject* player;
@property(nonatomic,strong) YBPlugin* plugin;
@property(nonatomic,strong) YBBrightcoveAdapter* adapter;

@end

@implementation YBBrightcoveAdapterSwiftWrapper

- (id) initWithPlayer:(NSObject*)player andPlugin:(YBPlugin*)plugin{
    if (self = [super init]) {
        self.player = player;
        self.plugin = plugin;
    }
    return self;
}

- (void) fireStart{
    [self initAdapterIfNecessary];
    [self.plugin.adapter fireStart];
}

- (void) fireStop{
    if(self.plugin != nil){
        if(self.plugin.adapter != nil){
            [self initAdapterIfNecessary];
            [self.plugin.adapter fireStop];
            [self.plugin removeAdapter];
        }
    }
    
}
- (void) firePause{
    [self initAdapterIfNecessary];
    [self.plugin.adapter firePause];
}
- (void) fireResume{
    [self initAdapterIfNecessary];
    [self.plugin.adapter fireResume];
}
- (void) fireJoin{
    [self initAdapterIfNecessary];
    [self.plugin.adapter fireJoin];
}

- (YBBrightcoveAdapter *) getAdapter{
    return self.adapter;
}

- (YBPlugin *) getPlugin{
    return self.plugin;
}

- (void) initAdapterIfNecessary{
    if(self.plugin.adapter == nil){
        if(self.plugin != nil){
            BCovePlayer bcPlayer = (BCovePlayer) self.player;
            
            [self.plugin setAdapter:[[YBBrightcoveAdapter alloc] initWithPlayer:bcPlayer]];
        }
    }
}

- (void) removeAdapter{
    [self.plugin removeAdapter];
}

@end
