//
//  ViewModelObjc.m
//  BrightcoveAdapterExample
//
//  Created by Tiago Pereira on 26/03/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "ViewModelObjc.h"
@import YouboraBrightcoveAdapter;

@interface ViewModelObjc ()

@property YBPlugin *plugin;

@end

@implementation ViewModelObjc

- (void)initPlugin:(YBOptions *)options {
    self.plugin = [[YBPlugin alloc] initWithOptions:options];
}

- (void)setAdapter:(id<BCOVPlaybackController>)player {
    [self.plugin setAdapter: [[YBBrightcoveAdapter alloc] initWithPlayer:player]];
}

- (void)setAdsAdapter:(id<BCOVPlaybackController>)player {
    [self.plugin setAdsAdapter: [[YBBrightcoveAdAdapter alloc] initWithPlayer:player]];
}

- (void)stopPlayer {
    [self.plugin fireStop];
    [self.plugin removeAdapter];
    [self.plugin removeAdsAdapter];
}

@end
