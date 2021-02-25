//
//  ViewController.m
//  PollfishMoPubAdapterExampleObjC
//
//  Created by Pollfish, Inc.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *showRewardedAdButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMoPub];
}

- (void) initializeMoPub {
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
            MPMoPubConfiguration *config = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization: adUnitid];
            
            [config setAdditionalNetworks:@[PollfishAdapterConfiguration.class]];
            
            [[MoPub sharedInstance] initializeSdkWithConfiguration: config completion:^(void) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadAd];
                });
            }];
        }
    }];
}

/*
    Pollfish Api Key and other configuration options are
    provided by MobPub's Web UI.
 */
- (void) loadAd {
    [_showRewardedAdButton setEnabled:false];
    
    [MPRewardedAds setDelegate:self forAdUnitId:adUnitid];
    
    [MPRewardedAds loadRewardedAdWithAdUnitID:adUnitid withMediationSettings:@[]];
}

/*
 Pollfish Api Key and other configuration options are
 provided by local extras during ad request.
 */
/*
- (void) loadAd {
    [_rewardLabel setHidden:true];
    [_showRewardedAdButton setEnabled:false];
    
    [MPRewardedAds setDelegate:self forAdUnitId:adUnitid];
    
    NSDictionary *localExtras = @{
        @"api_key": @"API_KEY",
        @"offerwall_mode": @true,
        @"release_mode": @true,
        @"request_uuid": @"USER_ID"};

    [MPRewardedAds loadRewardedAdWithAdUnitID:adUnitid
                   keywords:NULL
                   userDataKeywords:NULL
                   customerId:NULL
                   mediationSettings:NULL
                   localExtras:localExtras];
}
 */

- (void) rewardedAdDidLoadForAdUnitID:(NSString *)adUnitID {
    [_showRewardedAdButton setEnabled:true];
}

- (void) rewardedAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    [_showRewardedAdButton setEnabled:false];
}

- (void) rewardedAdDidPresentForAdUnitID:(NSString *)adUnitID {
    NSLog(@"Rewarded Ad Did Present");
}

- (void) rewardedAdDidDismissForAdUnitID:(NSString *)adUnitID {
    NSLog(@"Rewarded Ad Did Dismiss");
    [self loadAd];
}

- (void) rewardedAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPReward *)reward {
    NSLog(@"Rewarded Ad Did Reward With Amount: %@ %@", reward.amount, reward.currencyType);
}

- (IBAction)onShowRewardedAd:(id)sender {
    [MPRewardedAds presentRewardedAdForAdUnitID:adUnitid fromViewController:self withReward:NULL];
}

@end
