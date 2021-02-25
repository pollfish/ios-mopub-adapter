# Pollfish iOS MoPub Mediation Adapter

MoPub Mediation Adapter for iOS apps looking to load and show Rewarded Surveys from Pollfish in the same waterfall with other Rewarded Ads.

> **Note:** A detailed step by step guide is provided on how to integrate can be found [here](https://www.pollfish.com/docs/ios-mopub-adapter)

<br/>

## Step 1: Add Pollfish MoPub Adapter to your project

### Manually import PollfishMoPubAdapter

Download the following frameworks 

* [Pollfish SDK](https://www.pollfish.com/docs/ios)
* [MoPub SDK](https://github.com/mopub/mopub-ios-sdk#manual-integration-with-dynamic-framework)
* [PollfishMoPubAdapter](https://github.com/pollfish/ios-mopub-adapter)

and add them in your App's target dependecies

1. Navigate to your project
2. Select your App's target and go to the General tab section Frameworks, Libraries and Embedded Content
3. Add all three dependent framewokrs one by one by pressing the + button -> Add other and selecting the appropriate framework.

Add the following frameworks (if you don’t already have them) in your project

- AdSupport.framework  
- CoreTelephony.framework
- SystemConfiguration.framework 
- WebKit.framework (added in Pollfish v4.4.0)

**OR**

### **Retrieve Pollfish MoPub Adapter through CocoaPods**

Add a Podfile with PollfishMoPubAdapter pod reference:

```
pod 'PollfishMoPubAdapter'
```
You can find latest Pollfish iOS SDK version on CocoaPods [here](https://cocoapods.org/pods/PollfishMoPubAdapter)

Run pod install on the command line to install Pollfish cocoapod.

<br/>

## Important step Objective-C based projects

For Objective-C based projects you will need to create an empty Swift file and a bridging header file named `YourProjectName-Bridging-Header.h`. Skipping this step will result to compilation failure.

<br/>

## Step 2: Request for a RewardedAd

Import `PollfishMoPubAdapter` and `MoPubSDK`

<span style="text-decoration:underline">Swift</span>

```swift
import PollfishMoPubAdapter
import MoPubSDK
```

<span style="text-decoration:underline">Objective C</span>

```objc
@import PollfishMoPubAdapter;
#import <MoPubSDK/MoPub.h>
```

Initialize MoPub SDK and pass `PollfishAdapterConfiguration` on the initialisation configuration.

<span style="text-decoration:underline">Swift</span>

```swift
let config = MPMoPubConfiguration(adUnitIdForAppInitialization: "AD_UNIT_ID")

config.additionalNetworks = [PollfishAdapterConfiguration.self]

MoPub.sharedInstance().initializeSdk(with: config) {
    // Load Ad
}
```

<span style="text-decoration:underline">Objective C</span>

```objc
MPMoPubConfiguration *config = [[MPMoPubConfiguration alloc] 
    initWithAdUnitIdForAppInitialization:@"AD_UNIT_ID"];
[config setAdditionalNetworks:@[PollfishAdapterConfiguration.class]];

[[MoPub sharedInstance] initializeSdkWithConfiguration: config 
                        completion:^(void) {
    // Load Ad
}];
```

Request a RewardedAd from MoPub using the Pollfish configuration params that you provided on MoPub's Web UI (step 2). If no configuration is provided or if you want to override any of those params provided in the Web UI please see step 3.

<span style="text-decoration:underline">Swift</span>

```swift
MPRewardedAds.setDelegate(self, forAdUnitId: "AD_UNIT_ID")
        
MPRewardedAds.loadRewardedAd(withAdUnitID: "AD_UNIT_ID", 
                             withMediationSettings: nil)
```

<span style="text-decoration:underline">Objective C</span>

```objc
[MPRewardedAds setDelegate:self forAdUnitId:@"AD_UNIT_ID"];
    
[MPRewardedAds loadRewardedAdWithAdUnitID:@"AD_UNIT_ID" withMediationSettings:@[]];
```

Comform to `MPRewardedAdsDelegate` to get notified when the rewarded ad is ready to be shown

<span style="text-decoration:underline">Swift</span>

```swift
extension ViewController: MPRewardedAdsDelegate {
    
    func rewardedAdDidLoad(forAdUnitID adUnitID: String!) {}
    
    func rewardedAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {}
    
}
```

<span style="text-decoration:underline">Objective C</span>

```objc
// ViewController.h

@interface ViewController : UIViewController<MPRewardedAdsDelegate>

...

@end

// ViewController.m
@implementation ViewController

...

- (void) rewardedAdDidLoadForAdUnitID:(NSString *)adUnitID {}

- (void) rewardedAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {}

@end
```

When the Rewarded Ad is ready present the ad by invoking `presentRewardedAd`

<span style="text-decoration:underline">Swift</span>

```swift
MPRewardedAds.presentRewardedAd(forAdUnitID: unitId,
                                from: self,
                                with: nil)
```

<span style="text-decoration:underline">Objective C</span>

```objc
[MPRewardedAds presentRewardedAdForAdUnitID:@"AD_UNIT_ID" 
               fromViewController:self 
               withReward:NULL];
```

<br/>

### Step 3: Use and control Pollfish MoPub Adapter in your Rewarded Ad Unit 

Pollfish MoPub Adapter provides different options that you can use to control the behaviour of Pollfish SDK.

<br/>

Below you can see all the key-kalue available options of that is used to configure the behaviour of Pollfish SDK.

<br/>

No | Description
------------ | -------------
3.1 | **`api_key: String`**  <br/> Sets Pollfish SDK API key as provided by Pollfish
3.2 | **`request_uuid: Bool`**  <br/> Sets a unique id to identify a user and be passed through server-to-server callbacks
3.3 | **`release_mode: Bool`**  <br/> Sets Pollfish SDK to Developer or Release mode
3.4 | **`offerwall_mode: Bool`** <br/> Sets Pollfish SDK to Oferwall Mode  

<br/>

#### **3.1 `api_key`**

Pollfish API Key as provided by Pollfish on [Pollfish Dashboard](https://www.pollfish.com/publisher/) after you sign up to the platform.  If you have already specified Pollfish API Key on MoPub's Web UI, this param will be ignored.

#### **3.2 `request_uuid`**

Sets a unique id to identify a user and be passed through server-to-server callbacks on survey completion. 

In order to register for such callbacks you can set up your server URL on your app's page on Pollfish Developer Dashboard and then pass your requestUUID through ParamsBuilder object during initialization. On each survey completion you will receive a callback to your server including the requestUUID param passed.

If you would like to read more on Pollfish s2s callbacks you can read the documentation [here](https://www.pollfish.com/docs/s2s)

#### **3.3 `release_mode`**

Sets Pollfish SDK to Developer or Release mode.

*   **Developer mode** is used to show to the developer how Pollfish surveys will be shown through an app (useful during development and testing).
*   **Release mode** is the mode to be used for a released app in any app store (start receiving paid surveys).

Pollfish MoPub Adapter runs Pollfish SDK in release mode by default. If you would like to test with Test survey, you should set release mode to fasle.

Below you can see an example on how you can pass info to Pollfish MoPub Adapter connfiguration:

```swift
let localExtras: [AnyHashable: Any] = [
    "api_key": "API_KEY",
    "release_mode": true,
    "offerwall_mode": true,
    "request_uuid": "USER_ID"]

MPRewardedAds.loadRewardedAd(
    withAdUnitID: "UNIT_ID",
    keywords: nil,
    userDataKeywords: nil,
    customerId: nil,
    mediationSettings: nil,
    localExtras: localExtras)
```

```objc
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
```

<br/>

### Step 4: Publish your app on the store

If you everything worked fine during the previous steps, you should turn Pollfish to release mode and publish your app.

> **Note:** After you take your app live, you should request your account to get verified through Pollfish Dashboard in the App Settings area.

> **Note:** There is an option to show **Standalone Demographic Questions** needed for Pollfish to target users with surveys even when no actually surveys are available. Those surveys do not deliver any revenue to the publisher (but they can increase fill rate) and therefore if you do not want to show such surveys in the Waterfall you should visit your **App Settings** are and disable that option.
