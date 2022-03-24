import GameKit

final class GameCenterManager {
    
    // MARK: Public attributes
    weak public var delegate: GameCenterDelegate?
    public static var shared = GameCenterManager()
    
    // MARK: Private attributes
    var gcEnabled: Bool!
    var gcDefaultLeaderBoard: String!
    
    private init() { }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local

        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if ((ViewController) != nil) {
                // Show game center login if player is not logged in
                self.delegate?.presentGameCenterLogin(ViewController!, animated: true, completion: {})
            }
            else if (localPlayer.isAuthenticated) {
                
                print("player is authenticated")
                
                // Player is already authenticated and logged in
                self.gcEnabled = true

                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print("errors while loading default leaderboard identifiers")
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
        print("gcEnabled: \(String(describing: gcEnabled)), gcDefaultLeaderboard: \(String(describing: gcDefaultLeaderBoard))")
    }
    
    func updateGameCenterScore(with value:Int) {
        if (gcEnabled) {
            print(gcEnabled)
            GKLeaderboard.submitScore(value,
                                      context: 0,
                                      player: GKLocalPlayer.local,
                                      leaderboardIDs: [gcDefaultLeaderBoard],
                                      completionHandler: {error in})
        }
    }
}
