//
//  MainMenuViewController.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 03/03/22.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    private var playButton, leaderboardButton, settingsButton: UIButton!
    weak private var mainMenuDelegate: MainMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignBackgroundImage()
        
        addPlayButton()
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
        playButton.backgroundColor = .cyan
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
    
    @objc func playButtonTapped() {
        print("Jonas")
        self.dismiss(animated: false, completion: nil)
    }
}
