//
//  MainMenuViewController.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 03/03/22.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    private var playButton, leaderboardButton, settingsButton: UIButton!
    private var settingsView: SettingsView!
    
    public weak var mainMenuDelegate: MainMenuDelegate?
    public let audioPlayer = SuperSlalomAudioPlayer.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignBackgroundImage()
        
        setupPlayButton()
        setupSettingsButton()
        setupLeaderboardButton()
        
        setupSettingsView()
        
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
//        mainMenuDelegate?.startGame()
//        navigationController?.pushViewController(GameViewController(), animated: true)
        print("Play button tapped")
    }
    
    @objc func settingsButtonTapped() {
        settingsView.isHidden = false
    }
    
    @objc func leaderboardButtonTapped() {
        print("leaderboardTapped")
    }
}
