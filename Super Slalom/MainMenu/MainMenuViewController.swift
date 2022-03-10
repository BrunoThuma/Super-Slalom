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
    weak var mainMenuDelegate: MainMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignBackgroundImage()
        
        addPlayButton()
        
        showSettingsView()
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
    
    private func addPlayButton() {
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
    
    private func showSettingsView() {
        settingsView = SettingsView(musicIsOn: true, soundsAreOn: false)
        
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
        
        settingsView.recalculateBackgroundConstraints()
    }
    
    @objc func playButtonTapped() {
        mainMenuDelegate?.startGame()
    }
}
