//
//  YBBrightcoveAdapterSwiftWrapper.h
//  YouboraBrightcoveAdapter
//
//  Created by Enrique Alfonso Burillo on 29/12/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YBBrightcoveAdapter, YBPlugin;

__attribute__ ((deprecated)) DEPRECATED_MSG_ATTRIBUTE("This class is deprecated. Use YBBrightcoveAdapterSwiftTransformer instead")
@interface YBBrightcoveAdapterSwiftWrapper : NSObject

- (id) initWithPlayer:(NSObject*)player andPlugin:(YBPlugin*)plugin;
- (void) fireStart;
- (void) fireStop;
- (void) firePause;
- (void) fireResume;
- (void) fireJoin;

- (YBPlugin *) getPlugin;
- (YBBrightcoveAdapter *) getAdapter;
- (void) removeAdapter;

@end
