//
//  ViewModelSwift.swift
//  BrightcoveAdapterExample
//
//  Created by Tiago Pereira on 26/03/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation
import YouboraLib
import YouboraBrightcoveAdapter

class ViewModelSwift: NSObject, ViewModel {
    var plugin: YBPlugin?
    
    func initPlugin(_ options: YBOptions!) {
        plugin = YBPlugin(options: options)
    }
    
    func setAdapter(_ player: BCOVPlaybackController!) {
        self.plugin?.adapter = YBBrightcoveAdapterSwiftTransformer.transform(from: YBBrightcoveAdapter(player: player))
    }
    
    func setAdsAdapter(_ player: BCOVPlaybackController!) {
        self.plugin?.adsAdapter = YBBrightcoveAdapterSwiftTransformer.transform(fromAdsAdapter: YBBrightcoveAdAdapter(player: player))
    }
    
    func stopPlayer() {
        self.plugin?.fireStop()
        self.plugin?.removeAdapter()
        self.plugin?.removeAdsAdapter()
    }
}
