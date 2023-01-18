//
//  ViewModelObjc.h
//  BrightcoveAdapterExample
//
//  Created by Tiago Pereira on 26/03/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@import BrightcovePlayerSDK;
@import BrightcoveIMA;
@import YouboraLib;

@protocol ViewModel <NSObject>

-(void)initPlugin:(YBOptions*)options;
-(void)setAdapter:(id<BCOVPlaybackController>)player;
-(void)setAdsAdapter:(id<BCOVPlaybackController>)player;
-(void)stopPlayer;


@end

@interface ViewModelObjc : NSObject <ViewModel>

@end
