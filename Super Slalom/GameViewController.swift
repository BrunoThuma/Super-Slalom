import UIKit
import GameKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import FirebaseCrashlytics

class GameViewController: UIViewController, GADFullScreenContentDelegate {
    
    private var scene: GameScene!
    private var interstitial: GADInterstitialAd?
    private var gamesUntilAd: Int = 3
    private var mainMenuVC: MainMenuViewController!
    
    private var gcEnabled: Bool! // Check if the user has Game Center enabled
    private var gcDefaultLeaderBoard: String! // Check the default leaderboardID
    
    
    // MARK: overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestInterstitialAd()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.mainMenuVC == nil {
            // Initiate a MainMenuVC and asign self as delegate
            mainMenuVC = MainMenuViewController()
            mainMenuVC.mainMenuDelegate = self
            
            // Can only present new VCs when own view appears
            presentMainMenu()
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
    
    // MARK: Public methods
    /// Called by GameScene to present MainMenu
    func goToMainMenu() {
        presentMainMenu()
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
        scene.reset()
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
    
    func updateGameCenterScore(with value:Int) {
        if (self.gcEnabled) {
            GKLeaderboard.submitScore(value,
                                      context: 0,
                                      player: GKLocalPlayer.local,
                                      leaderboardIDs: [self.gcDefaultLeaderBoard],
                                      completionHandler: {error in})
        }
    }
    
    // MARK: Private methods
    private func presentMainMenu() {
        mainMenuVC.modalPresentationStyle = .fullScreen
        present(mainMenuVC, animated: false, completion: nil)
    }
    
    private func presentGameScene() {
        if let view = self.view as! SKView? {

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
    
    /// Tells the delegate that the ad presented full screen content.
    private func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
}

extension GameViewController: MainMenuDelegate {
    func startGame() {
        mainMenuVC.dismiss(animated: false, completion: nil)
        
        if scene == nil {
            // Load the SKScene from 'GameScene.sks'
            // FIXME: Use delegate instead of cross reference
            scene = (SKScene(fileNamed: "GameScene") as! GameScene)
            scene.gameViewController = self
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            self.presentGameScene()
        } else {
            self.restartGame()
        }
    }
}

// TODO: Make a file just for GameCenter authentication
extension GameViewController {
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local

        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if ((ViewController) != nil) {
                // Show game center login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            }
            else if (localPlayer.isAuthenticated) {
                
                // Player is already authenticated and logged in
                self.gcEnabled = true

                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print(error!)
                    }
                    else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                 })
            }
            else {
                // Game center is not enabled on the user's device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
    }
}
