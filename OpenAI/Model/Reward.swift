//
//  Reward.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

 import GoogleMobileAds

class Reward: NSObject, GADFullScreenContentDelegate, ObservableObject {
    @Published var rewardLoaded: Bool = false
    var rewardedAd: GADRewardedAd?

    override init() {
        super.init()
        self.LoadReward()
    }

    // リワード広告の読み込み
    func LoadReward() {
        let request = GADRequest()
            GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313",
                               request: request,
                               completionHandler: { [self] ad, error in
              if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                  print("😭: 読み込みに失敗しました")
                  self.rewardLoaded = false
                return
              }
                print("😍: 読み込みに成功しました")
                self.rewardLoaded = true
                self.rewardedAd = ad
                self.rewardedAd?.fullScreenContentDelegate = self
              print("Rewarded ad loaded.")
            }
        )
    }
}
