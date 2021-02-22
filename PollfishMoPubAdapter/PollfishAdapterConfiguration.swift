//
//  PollfishAdapterConfiguration.swift
//  PollfishMobpubAdapter
//
//  Created by Fotis Mitropoulos on 18/2/21.
//

import Foundation
import MoPubSDK
import Pollfish

public class PollfishAdapterConfiguration: MPBaseAdapterConfiguration {
    
    override public var adapterVersion: String {
        return Constants.version
    }
    
    override public var biddingToken: String? {
        return nil
    }
    
    override public var moPubNetworkName: String {
        return Constants.netwrokName
    }
    
    override public var networkSdkVersion: String {
        return Constants.pollfishVersion
    }
    
    override public func initializeNetwork(withConfiguration configuration: [String : Any]?,
                                           complete: ((Error?) -> Void)? = nil) {
        complete?(nil)
    }
    
}
