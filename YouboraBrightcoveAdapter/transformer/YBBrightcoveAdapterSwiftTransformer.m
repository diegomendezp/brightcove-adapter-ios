//
//  YBBrightcoveAdapterSwiftTransformer.m
//  YouboraBrightcoveAdapter
//
//  Created by Tiago Pereira on 26/03/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBBrightcoveAdapterSwiftTransformer.h"

@implementation YBBrightcoveAdapterSwiftTransformer

+(YBPlayerAdapter<id>*)transformFromAdapter:(YBBrightcoveAdapter*)adapter { return adapter; }
+(YBPlayerAdapter<id>*)transformFromAdsAdapter:(YBBrightcoveAdAdapter*)adapter { return adapter; }
+(YBPlayerAdapter<id>*)transformFromGenericAdsAdapter:(YBGenericAdsAdapter*)adapter { return adapter; }

@end
