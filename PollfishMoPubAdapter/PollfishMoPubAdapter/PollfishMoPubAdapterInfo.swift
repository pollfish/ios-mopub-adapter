//
//  PollfishMoPubAdapterInfo.swift
//  PollfishMoPubAdapter
//
//  Created by Pollfish, Inc.
//

import Foundation

struct PollfishMoPubAdaterInfo {
    
    let apiKey: String
    let releaseMode: Bool
    let offerwallMode: Bool
    let requestUUID: String?
    
    init?(remote: [AnyHashable: Any], local: [AnyHashable: Any]?) {
                
        if let localApiKey = local?[Constants.ExtraKey.apiKey] as? String {
            apiKey = localApiKey
        } else if let remoteApiKey = remote[Constants.ExtraKey.apiKey] as? String {
            apiKey = remoteApiKey
        } else {
            return nil
        }
        
        if let localReleaseMode = local?[Constants.ExtraKey.releaseMode] as? Bool {
            releaseMode = localReleaseMode
        } else if let remoteReleaseMode = remote[Constants.ExtraKey.releaseMode] as? Bool {
            releaseMode = remoteReleaseMode
        } else {
            releaseMode = true
        }
        
        if let localOfferwallMode = local?[Constants.ExtraKey.offerwallMode] as? Bool {
            offerwallMode = localOfferwallMode
        } else if let remoteOfferwallMode = remote[Constants.ExtraKey.offerwallMode] as? Bool {
            offerwallMode = remoteOfferwallMode
        } else {
            offerwallMode = false
        }
        
        if let localRequestUUID = local?[Constants.ExtraKey.requestUUID] as? String {
            requestUUID = localRequestUUID
        } else if let remoteRequestUUID = remote[Constants.ExtraKey.requestUUID] as? String {
            requestUUID = remoteRequestUUID
        } else {
            requestUUID = nil
        }
        
    }
}
