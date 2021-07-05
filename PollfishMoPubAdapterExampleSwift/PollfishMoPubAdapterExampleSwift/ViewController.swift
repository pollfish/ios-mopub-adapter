//
//  ViewController.swift
//  PollfishMobPubAdapterExampleSwift
//
//  Created by Pollfish, Inc.
//

import UIKit
import MoPubSDK
import PollfishMoPubAdapter
import AppTrackingTransparency

class ViewController: UIViewController {
    
    @IBOutlet weak var showRewardedAdButton: UIButton!
    
    let unitId = "REWARDED_AD_UNIT_ID"

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMoPub()
    }

    func initializeMoPub() {        
        let config = MPMoPubConfiguration(adUnitIdForAppInitialization: unitId)

        config.additionalNetworks = [
            PollfishAdapterConfiguration.self]
        config.loggingLevel = .debug
        
        ATTrackingManager.requestTrackingAuthorization { status in
            MoPub.sharedInstance().initializeSdk(with: config) {
                DispatchQueue.main.async {
                    self.loadAd()
                }
            }
        }
    }
    
    /*
        Pollfish Api Key and other configuration options are
        provided by MobPub's Web UI.
     */
    func loadAd() {
        showRewardedAdButton.isEnabled = false
        
        MPRewardedAds.setDelegate(self, forAdUnitId: unitId)
        
        MPRewardedAds.loadRewardedAd(withAdUnitID: unitId,
                                     keywords: nil,
                                     userDataKeywords: nil,
                                     customerId: nil,
                                     mediationSettings: nil,
                                     localExtras: nil)
    }
    
    /*
     Pollfish Api Key and other configuration options are
     provided by local extras during ad request.
     */
    /*
    func loadAd() {
        rewardLabel.isHidden = true
        showRewardedAdButton.isEnabled = false
     
        MPRewardedAds.setDelegate(self, forAdUnitId: unitId)
        
        let localExtras: [AnyHashable: Any] = [
            "api_key": "API_KEY",
            "release_mode": true,
            "offerwall_mode": true,
            "request_uuid": "REQUEST_UUID"
        ]
        
        MPRewardedAds.loadRewardedAd(withAdUnitID: unitId,
                                     keywords: nil,
                                     userDataKeywords: nil,
                                     customerId: nil,
                                     mediationSettings: nil,
                                     localExtras: localExtras)
    }
     */
    
    @IBAction func onShowRewardedAd(_ sender: Any) {
        MPRewardedAds.presentRewardedAd(forAdUnitID: unitId,
                                        from: self,
                                        with: nil)
    }

}

extension ViewController: MPRewardedAdsDelegate {
    
    func rewardedAdDidLoad(forAdUnitID adUnitID: String!) {
        self.showRewardedAdButton.isEnabled = true
    }
    
    func rewardedAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {
        self.showRewardedAdButton.isEnabled = false
    }
    
    func rewardedAdDidPresent(forAdUnitID adUnitID: String!) {
        NSLog("Rewarded Ad Did Present")
    }
    
    func rewardedAdDidDismiss(forAdUnitID adUnitID: String!) {
        NSLog("Rewarded Ad Did Dismiss")
        loadAd()
    }
    
    func rewardedAdShouldReward(forAdUnitID adUnitID: String!, reward: MPReward!) {
        NSLog("Rewarded Ad Did Reward With Amount: \(String(describing: reward.amount)) \(String(describing: reward.currencyType))")
    }
    
}
