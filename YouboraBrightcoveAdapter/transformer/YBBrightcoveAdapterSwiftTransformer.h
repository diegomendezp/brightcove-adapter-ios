//
//  YBBrightcoveAdapterSwiftTransformer.h
//  YouboraBrightcoveAdapter
//
//  Created by Tiago Pereira on 26/03/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBBrightcoveAdapter.h"
#import "YBBrightcoveAdAdapter.h"
#import "YBGenericAdsAdapter.h"

@interface YBBrightcoveAdapterSwiftTransformer : NSObject

+(YBPlayerAdapter<id>*)transformFromAdapter:(YBBrightcoveAdapter*)adapter;
+(YBPlayerAdapter<id>*)transformFromAdsAdapter:(YBBrightcoveAdAdapter*)adapter;
+(YBPlayerAdapter<id>*)transformFromGenericAdsAdapter:(YBGenericAdsAdapter*)adapter;

@end
