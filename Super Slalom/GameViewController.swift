//
//  GameViewController.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 28/01/22.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import FirebaseCrashlytics

class GameViewController: UIViewController, GADFullScreenContentDelegate {
    
    var scene: GameScene!
    private var interstitial: GADInterstitialAd?
    private var gamesUntilAd: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestInterstitialAd()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .cyan
        
        let mainMenuVC = MainMenuViewController()
        mainMenuVC.modalPresentationStyle = .fullScreen
        present(mainMenuVC, animated: false, completion: nil)
    }
    
    private func configureGameScene() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            // FIXME: Use delegate instead of cross reference
            scene = (SKScene(fileNamed: "GameScene") as! GameScene)
            scene.gameViewController = self
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill

            // Present the scene
            view.presentScene(scene)

            view.ignoresSiblingOrder = true

            #if DEBUG
                view.showsFPS = true
                view.showsNodeCount = true
            #elseif RELEASE
                view.showsFPS = false
                view.showsNodeCount = false
            #endif
        }
    }
    
    // Codigo de teste: ca-app-pub-3940256099942544/4411468910
    // Codigo real insterticial: ca-app-pub-2446678848694050/1742674548
    func requestInterstitialAd() {
        
        let interstitialToken: String
        
        #if DEBUG
            interstitialToken = "ca-app-pub-3940256099942544/4411468910"
        #elseif RELEASE
            interstitialToken = "ca-app-pub-2446678848694050/1742674548"
        #endif
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: interstitialToken,
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
        scene.reset()
    }
    
    /// Tells the delegate that the ad presented full screen content.
    private func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        requestInterstitialAd()
        scene.reset()
    }
    
    func restartGame() {
        gamesUntilAd -= 1
        
        if gamesUntilAd <= 0 {
            gamesUntilAd = 3
            shouldDisplayInterstitial()
        } else {
            scene.reset()
        }
    }
    
    func shouldDisplayInterstitial() {
        if interstitial != nil {
            interstitial!.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
