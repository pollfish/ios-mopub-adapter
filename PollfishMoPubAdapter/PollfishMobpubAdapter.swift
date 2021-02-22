//
//  PollfishMobpubAdapter.swift
//  PollfishMobpubAdapter
//
//  Created by Fotis Mitropoulos on 18/2/21.
//

import MoPubSDK
import Pollfish

@objc public class MoPubRewardedAdPollifsh: MPFullscreenAdAdapter, MPThirdPartyFullscreenAdAdapter {
    
    override public var isRewardExpected: Bool {
        return true
    }
        
    override public func requestAd(withAdapterInfo info: [AnyHashable : Any], adMarkup: String?) {
        MPLogging.logEvent(MPLogEvent(message: "Requesting Ad form Pollfish", level: .debug),
                           source: nil, from: self.classForCoder)
        
        if (Pollfish.isPollfishPresent()) {
            let error = PollfishMoPubAdapterError.surveyAlreadyPresent
            
            MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                               source: nil, from: self.classForCoder)
            
            self.delegate?.fullscreenAdAdapter(self, didFailToLoadAdWithError: error)
            return
        }
        
        guard let adapterInfo = PollfishMoPubAdaterInfo(from: info) else {
            let error = PollfishMoPubAdapterError.noApiKey
            
            MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                               source: nil, from: self.classForCoder)
            
            self.delegate?.fullscreenAdAdapter(self, didFailToLoadAdWithError: error)
            return
        }
        
        // TODO: Retrieve params
        
        let params = PollfishParams()
        params.indicatorPosition = Int32(PollfishPosition.PollFishPositionMiddleRight.rawValue)
        params.releaseMode = adapterInfo.releaseMode
        params.rewardMode = true
        
        if let requestUUID = adapterInfo.requestUUID {
            params.requestUUID = requestUUID
        }
        
        params.offerwallMode = adapterInfo.offerwallMode
        
        if let rootView = UIApplication.shared.windows.last?.window?.rootViewController?.view {
            params.pollfishViewContainer = rootView
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(pollfishNotAvailable),
            name: NSNotification.Name(rawValue: "PollfishSurveyNotAvailable"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(pollfishSurveyCompleted),
            name: NSNotification.Name(rawValue: "PollfishSurveyCompleted"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(pollfishSurveyReceived),
            name: NSNotification.Name(rawValue: "PollfishSurveyReceived"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(pollfishOpened),
            name: NSNotification.Name(rawValue: "PollfishOpened"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(pollfishClosed),
            name: NSNotification.Name(rawValue: "PollfishClosed"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(pollfishUserNotEligible),
            name: NSNotification.Name(rawValue: "PollfishUserNotEligible"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(pollfishUserRejectedSurvey),
            name: NSNotification.Name(rawValue: "PollfishUserRejectedSurvey"),
            object: nil)
        
        Pollfish.initWithAPIKey(adapterInfo.apiKey, andParams: params)
    }
    
    override public func presentAd(from viewController: UIViewController) {
        Pollfish.show()
    }
    
    @objc func pollfishNotAvailable(_ notification: NSNotification) {
        let error = PollfishMoPubAdapterError.surveyNotAvailable
        
        MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                           source: nil, from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapter(
            self,
            didFailToShowAdWithError: error)
    }
    
    @objc func pollfishSurveyCompleted(_ notification: NSNotification) {
        let rewardValue = notification.userInfo?["reward_value"] as? Int
        let rewardCurrency = notification.userInfo?["reward_name"] as? String
        
        guard let reward = MPReward(currencyType: rewardCurrency,
                                    amount: rewardValue as NSNumber?) else { return }
        
        MPLogging.logEvent(MPLogEvent(message: "Survey Completed: \(reward)", level: .debug),
                           source: nil, from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapter(self, willRewardUser: reward)
    }
    
    @objc func pollfishSurveyReceived(_ notification: NSNotification) {
        MPLogging.logEvent(MPLogEvent(message: "Survey Received", level: .debug),
                           source: nil, from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterDidLoadAd(self)
    }
    
    @objc func pollfishOpened(_ notification: NSNotification) {
        MPLogging.logEvent(MPLogEvent(message: "Survey Opened", level: .debug),
                           source: nil, from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterAdDidAppear(self)
    }
    
    @objc func pollfishClosed(_ notification: NSNotification) {
        MPLogging.logEvent(MPLogEvent(message: "Survey Closed", level: .debug),
                           source: nil, from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterAdDidDisappear(self)
    }
    
    @objc func pollfishUserNotEligible(_ notification: NSNotification) {
        MPLogging.logEvent(MPLogEvent(message: "User Not Eligible", level: .debug),
                           source: nil, from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterAdWillDismiss(self)
        self.delegate?.fullscreenAdAdapterAdDidDismiss(self)
    }
    
    @objc func pollfishUserRejectedSurvey(_ notification: NSNotification) {
        MPLogging.logEvent(MPLogEvent(message: "User Rejected Survey", level: .debug),
                           source: nil, from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterAdWillDismiss(self)
        self.delegate?.fullscreenAdAdapterAdDidDismiss(self)
    }
    
}
