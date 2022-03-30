import UIKit
import GameKit

class MainMenuViewController: UIViewController {
    
    private var playButton, leaderboardButton, settingsButton: UIButton!
    private var settingsView: SettingsView!
    
    public let audioPlayer = SuperSlalomAudioPlayer.shared
    
    private var gcEnabled: Bool! // Check if the user has Game Center enabled
    private var gcDefaultLeaderBoard: String! // Check the default leaderboardID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignBackgroundImage()
        
        setupPlayButton()
        setupSettingsButton()
        setupLeaderboardButton()
        
        setupSettingsView()
        
        GameCenterManager.shared.delegate = self
        GameCenterManager.shared.authenticateLocalPlayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.settingsView {
            settingsView.isHidden = true
        }
    }
    
    private func assignBackgroundImage() {
        let backgroundImage = UIImage(named: "mainmenu_background")
        
        let imageView = UIImageView(frame: view.frame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = false
        imageView.image = backgroundImage
        imageView.center = view.center
        imageView.layer.position.x += 10
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    private func setupPlayButton() {
        playButton = UIButton(type: .custom)
        playButton.setImage(UIImage(named: "mainmenu_play_button"), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        view.addSubview(playButton)
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupSettingsButton() {
        settingsButton = UIButton(type: .custom)
        settingsButton.setImage(UIImage(named: "mainmenu_settings_button"), for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        view.addSubview(settingsButton)
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            settingsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupSettingsView() {
        settingsView = SettingsView(musicIsOn: true,
                                    musicClosure: switchedMusicToggle,
                                    soundsAreOn: true,
                                    soundsClosure: switchedSoundsToggle)
        
        view.addSubview(settingsView)
        
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        let bgImgSize = settingsView.bgImage.size
        
        let constraints = [
            settingsView.widthAnchor.constraint(equalToConstant: bgImgSize.width),
            settingsView.heightAnchor.constraint(equalToConstant: bgImgSize.height),
            settingsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        settingsView.isHidden = true
    }
    
    private func setupLeaderboardButton() {
        settingsButton = UIButton(type: .custom)
        settingsButton.setImage(UIImage(named: "mainmenu_leaderboards_button"), for: .normal)
        settingsButton.addTarget(self, action: #selector(leaderboardButtonTapped), for: .touchUpInside)
        
        view.addSubview(settingsButton)
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            settingsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func switchedSoundsToggle(_ toggleIsOn: Bool) {
        if toggleIsOn {
            audioPlayer.muteSounds()
        } else {
            audioPlayer.muteSounds()
        }
    }
    
    func switchedMusicToggle(_ toggleIsOn: Bool) {
        if toggleIsOn {
            audioPlayer.unmuteMusic()
        } else {
            audioPlayer.muteMusic()
        }
    }
    
    @objc func playButtonTapped() {
        navigationController?.pushViewController(GameViewController(), animated: true)
    }
    
    @objc func settingsButtonTapped() {
        settingsView.isHidden = false
    }
    
    @objc func leaderboardButtonTapped() {
        print("Presenting laederboardVC")
        
//        guard GameCenterManager.shared.gcDefaultLeaderBoard != nil else {
//            self.alertLeaderboardNotAvailable()
//            return
//        }
        
        let gameCenterVC = GKGameCenterViewController(leaderboardID: GameCenterManager.shared.gcDefaultLeaderBoard,
                                                      playerScope: .global,
                                                      timeScope: .allTime)
        gameCenterVC.gameCenterDelegate = self
        present(gameCenterVC, animated: true, completion: nil)
    }
}


extension MainMenuViewController: GameCenterDelegate {
    func presentGameCenterLogin(_ vc: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        self.present(vc, animated: animated, completion: completion)
    }
    
    func alertLeaderboardNotAvailable() {
        let alert = UIAlertController(title: "Leaderboard not Available",
                                      message: "Leaderboard could not be loaded, default leaderboard value is \(String(describing: GameCenterManager.shared.gcDefaultLeaderBoard))",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                      style: .default,
                                      handler: { _ in }))
        
        self.present(alert, animated: true, completion: nil)
    }
}


extension MainMenuViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}
