import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import FirebaseCrashlytics

class GameViewController: UIViewController, GADFullScreenContentDelegate {
    
    private var gameScene: GameScene!
    private var interstitial: GADInterstitialAd?
    private var adsManager = SuperSlalomAdsManager.shared
    
    // MARK: overriden methods
    override func loadView() {
        self.view = SKView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        requestInterstitialAd()
        
        super.viewDidLoad()
        
        startGame()
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
    
    // MARK: Public methods
    /// Called by GameScene to present MainMenu
    func goToMainMenu() {
        adsManager.gamesUntilAd -= 1
        
        if adsManager.gamesUntilAd <= 0 {
            adsManager.gamesUntilAd = 3
            shouldDisplayInterstitial()
        }
        
        self.dismiss(animated: true)
    }
    
    func requestInterstitialAd() {
        
        let interstitialToken: String
        
        #if DEBUG
            // Test ad code
            interstitialToken = "ca-app-pub-3940256099942544/4411468910"
        #elseif RELEASE
            // Real ad code
            interstitialToken = "ca-app-pub-2446678848694050/1742674548"
        #else
            // Real ad code
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
        gameScene.reset()
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        requestInterstitialAd()
        gameScene.reset()
    }
    
    func restartGame() {
        adsManager.gamesUntilAd -= 1
        
        if adsManager.gamesUntilAd <= 0 {
            adsManager.gamesUntilAd = 3
            shouldDisplayInterstitial()
        } else {
            gameScene.reset()
        }
    }
    
    func shouldDisplayInterstitial() {
        if interstitial != nil {
            interstitial!.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    private func presentGameScene() {
        if let view = self.view as! SKView? {

            view.presentScene(gameScene)

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
    
    private func startGame() {
        if gameScene == nil {
            // Load the SKScene from 'GameScene.sks'
            // FIXME: Use delegate instead of cross reference
            gameScene = (SKScene(fileNamed: "GameScene") as! GameScene)
            gameScene.gameViewController = self
            // Set the scale mode to scale to fit the window
            gameScene.scaleMode = .aspectFill
            
            self.presentGameScene()
        } else {
            self.restartGame()
        }
    }
    
    /// Tells the delegate that the ad presented full screen content.
    private func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
}
