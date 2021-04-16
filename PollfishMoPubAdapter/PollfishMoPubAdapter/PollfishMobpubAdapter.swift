//
//  PollfishMobpubAdapter.swift
//  PollfishMobpubAdapter
//
//  Created by Pollfish, Inc.
//

import MoPubSDK
import Pollfish

@objc(MoPubRewardedAdPollifsh)
public class MoPubRewardedAdPollifsh: MPFullscreenAdAdapter, MPThirdPartyFullscreenAdAdapter, PollfishDelegate {
    
    override public var isRewardExpected: Bool {
        return true
    }
        
    @objc override public func requestAd(withAdapterInfo info: [AnyHashable : Any], adMarkup: String?) {
        
        MPLogging.logEvent(MPLogEvent(message: "Requesting Ad form Pollfish", level: .debug),
                           source: nil, from: self.classForCoder)
                
        if (Pollfish.isPollfishPresent()) {
            let error = PollfishMoPubAdapterError.surveyAlreadyPresent
            
            MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                               source: nil, from: self.classForCoder)
            
            self.delegate?.fullscreenAdAdapter(self, didFailToLoadAdWithError: error)
            return
        }
        
        guard let adapterInfo = PollfishMoPubAdaterInfo(remote: info, local: localExtras) else {
            let error = PollfishMoPubAdapterError.noApiKey
            
            MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                               source: nil, from: self.classForCoder)
            
            self.delegate?.fullscreenAdAdapter(self, didFailToLoadAdWithError: error)
            return
        }
        
        let params = PollfishParams(adapterInfo.apiKey)
            .indicatorPosition(.middleRight)
            .releaseMode(adapterInfo.releaseMode)
            .rewardMode(true)
        
        if let requestUUID = adapterInfo.requestUUID {
            params.requestUUID(requestUUID)
        }
        
        params.offerwallMode(adapterInfo.offerwallMode)
        
        if let rootView = UIApplication.shared.windows.last?.window?.rootViewController?.view {
            params.viewContainer(rootView)
        }
        
        Pollfish.initWith(params, delegate: self)
    }
    
    @objc override public func presentAd(from viewController: UIViewController) {
        Pollfish.show()
    }
    
    public func pollfishSurveyCompleted(surveyInfo: SurveyInfo) {
        let rewardValue = surveyInfo.rewardValue
        let rewardCurrency = surveyInfo.rewardName
        
        guard let reward = MPReward(currencyType: rewardCurrency,
                                    amount: rewardValue as NSNumber?) else { return }
        
        MPLogging.logEvent(MPLogEvent(message: "Survey Completed: \(reward)", level: .debug),
                           source: nil, from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapter(self, willRewardUser: reward)
    }
    
    public func pollfishSurveyReceived(surveyInfo: SurveyInfo?) {
        MPLogging.logEvent(MPLogEvent(message: "Survey Received", level: .debug),
                           source: nil, from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterDidLoadAd(self)
    }
    
    public func pollfishOpened() {
        MPLogging.logEvent(MPLogEvent(message: "Survey Opened", level: .debug),
                           source: nil, from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterAdDidAppear(self)
    }
    
    public func pollfishClosed() {
        MPLogging.logEvent(MPLogEvent(message: "Survey Closed", level: .debug),
                           source: nil, from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterAdDidDisappear(self)
    }
    
    public func pollfishUserNotEligible() {
        MPLogging.logEvent(MPLogEvent(message: "User Not Eligible", level: .debug),
                           source: nil, from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterAdWillDismiss(self)
        self.delegate?.fullscreenAdAdapterAdDidDismiss(self)
    }
    
    public func pollfishUserRejectedSurvey() {
        MPLogging.logEvent(MPLogEvent(message: "User Rejected Survey", level: .debug),
                           source: nil, from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterAdWillDismiss(self)
        self.delegate?.fullscreenAdAdapterAdDidDismiss(self)
    }
    
    public func pollfishSurveyNotAvailable() {
        let error = PollfishMoPubAdapterError.surveyNotAvailable
        
        MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                           source: nil, from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapter(
            self,
            didFailToShowAdWithError: error)
    }
    
}
