// Copyright (c) 2016-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to
// use, copy, modify, and distribute this software in source code or binary
// form for use in connection with the web services and APIs provided by
// Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "ViewController.h"

@interface ViewController () <GADBannerViewDelegate>
@property (nonatomic, strong) GADInterstitial *interstitial;
@end

// AdMob ad unit IDs, in the format of @"ca-app-pub-xxxx/yyyy", you should replace with your own
static NSString *const MyBannerAdUnitID = @"ca-app-pub-1132976788633171/5437301072";
static NSString *const MyInterstitialAdUnitID = @"ca-app-pub-1132976788633171/9106396428";

static NSString *const ClickToLoadInterstital = @"Click to load interstitial";
static NSString *const InterstitalLoading = @"Interstitial loading...";
static NSString *const InterstitalLoaded = @"Interstitial loaded! Click to show!";


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load the banner
    self.bannerView.adUnitID = MyBannerAdUnitID;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    [self refreshBanner];
    
    // Interstital
    self.interstitialStatus.text = ClickToLoadInterstital;
}

- (IBAction)onShowInterstitial:(id)sender {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"Interstitial wasn't ready!");
    }
}

- (IBAction)onLoadInterstitial:(id)sender {
    [self requestInterstitial];
}

- (IBAction)onRefreshBanner:(id)sender {
    [self refreshBanner];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshBanner {
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ @"29e7dce5fbad9bc32a3ef3680facce36", @"532d88c6dc671d9ba300c0b10976e440", kGADSimulatorID ];
    [self.bannerView loadRequest:request];
}

- (void)requestInterstitial {
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:MyInterstitialAdUnitID];
    self.interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ @"29e7dce5fbad9bc32a3ef3680facce36", @"532d88c6dc671d9ba300c0b10976e440", kGADSimulatorID ];
    [self.interstitial loadRequest:request];

    self.interstitialStatus.text = InterstitalLoading;
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    self.interstitialStatus.text = InterstitalLoaded;
    NSLog(@"Interstitial adapter class name: %@", ad.adNetworkClassName);
    //GADMAdapterGoogleAdMobAds

}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    self.interstitialStatus.text = ClickToLoadInterstital;
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    self.interstitialStatus.text = ClickToLoadInterstital;
    NSLog(@"%@", error.description);
}

-(void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"bannerView RECEIVED");
    NSLog(@"Banner adapter class name: %@", bannerView.adNetworkClassName);
    //GADMAdapterGoogleAdMobAds

}

-(void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%@", error.description);
}


@end
