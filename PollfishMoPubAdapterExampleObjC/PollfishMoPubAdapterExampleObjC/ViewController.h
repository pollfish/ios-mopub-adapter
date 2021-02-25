//
//  ViewController.h
//  PollfishMoPubAdapterExampleObjC
//
//  Created by Pollfish, Inc.
//

#import <UIKit/UIKit.h>
#import <MoPubSDK/MoPub.h>
#import <AppTrackingTransparency/ATTrackingManager.h>
@import PollfishMoPubAdapter;

NSString *const adUnitid = @"REWARDED_AD_UNIT_ID";

@interface ViewController : UIViewController<MPRewardedAdsDelegate>

@end

