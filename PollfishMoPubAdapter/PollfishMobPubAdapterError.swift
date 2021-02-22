//
//  PollfishMobPubAdapterError.swift
//  PollfishMoPubAdapter
//
//  Created by Fotis Mitropoulos on 18/2/21.
//

import Foundation

enum PollfishMoPubAdapterError: Error, CustomStringConvertible {
    case surveyAlreadyPresent
    case surveyNotAvailable
    case noApiKey
    
    var description: String {
        switch self {
        case .surveyAlreadyPresent: return "Survey Already Present, Skipping"
        case .surveyNotAvailable: return "Survey Not Available"
        case .noApiKey: return "No Api Key"
        }
    }
    
}
