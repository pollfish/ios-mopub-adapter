//
//  PollfishMoPubAdapterInfo.swift
//  PollfishMoPubAdapter
//
//  Created by Fotis Mitropoulos on 18/2/21.
//

import Foundation

struct PollfishMoPubAdaterInfo {
    
    let apiKey: String
    let releaseMode: Bool
    let offerwallMode: Bool
    let requestUUID: String?
    
    init?(from dictionary: [AnyHashable: Any]) {
        guard let apiKey = dictionary["api_key"] as? String else { return nil }
        
        self.apiKey = apiKey
        self.releaseMode = dictionary["release_mode"] as? Bool ?? false
        self.offerwallMode = dictionary["offerwall_mode"] as? Bool ?? false
        self.requestUUID = dictionary["request_uuid"] as? String
    }
}
