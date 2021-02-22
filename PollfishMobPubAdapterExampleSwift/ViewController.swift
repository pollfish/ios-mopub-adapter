//
//  ViewController.swift
//  PollfishMobPubAdapterExampleSwift
//
//  Created by Fotis Mitropoulos on 19/2/21.
//

import UIKit
import MoPubSDK
import MoPub_AdMob_Adapters
//import MoP
//import MoPub_Vungle_Adapters
import PollfishMoPubAdapter

class ViewController: UIViewController {
    
    @IBOutlet weak var showRewardedAdButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeMoPub()
    }

    func initializeMoPub() {        
        let config = MPMoPubConfiguration(adUnitIdForAppInitialization: "c5d30645f8ee422c81ceb41bb651d190")

        config.additionalNetworks = [
            PollfishAdapterConfiguration.self,
            GoogleAdMobAdapterConfiguration.self]
        config.loggingLevel = .debug
        
        ATTrackingManager.requestTrackingAuthorization { status in
            if status == .authorized {
                MoPub.sharedInstance().initializeSdk(with: config, completion: {
                    DispatchQueue.main.async {
                        self.loadAd()
                    }
                })
            }
        }
    }
    
    func loadAd() {
        MPRewardedAds.setDelegate(self, forAdUnitId: "c5d30645f8ee422c81ceb41bb651d190")
        //MPRewardedVideo.setDelegate(self, forAdUnitId: "c5d30645f8ee422c81ceb41bb651d190")
        let extras: [String : Any] = ["api_key": "451066a2-2563-4964-9e5e-e1924b588d40"]
        
        MPRewardedAds.loadRewardedAd(withAdUnitID: "c5d30645f8ee422c81ceb41bb651d190",
                                     keywords: nil,
                                     userDataKeywords: nil,
                                     customerId: nil,
                                     mediationSettings: nil,
                                     localExtras: extras)
    
//        MPRewardedVideo.loadAd(withAdUnitID: "c5d30645f8ee422c81ceb41bb651d190",
//                               keywords: nil,
//                               userDataKeywords: nil,
//                               customerId: nil,
//                               mediationSettings: nil,
//                               localExtras: extras)
    }
    
    @IBAction func onShowRewardedAd(_ sender: Any) {
//        MPRewardedVideo.presentAd(forAdUnitID: "c5d30645f8ee422c81ceb41bb651d190",
//                                  from: self,
//                                  with: nil)
        MPRewardedAds.presentRewardedAd(forAdUnitID: "c5d30645f8ee422c81ceb41bb651d190",
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
}

//extension ViewController: MPRewardedVideoDelegate {
//
//    func rewardedVideoAdDidLoad(forAdUnitID adUnitID: String!) {
//        self.showRewardedAdButton.isEnabled = true
//    }
//
//    func rewardedVideoAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {
//        self.showRewardedAdButton.isEnabled = false
//    }
//
//}
