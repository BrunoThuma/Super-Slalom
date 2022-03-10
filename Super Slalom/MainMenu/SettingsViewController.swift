//
//  SettingsViewController.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 10/03/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var bgImage: UIImage!
    var musicToggle, soundsToggle: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(SettingsView(musicIsOn: false, soundsAreOn: false))
        
        self.musicToggle = UISwitch()
        self.soundsToggle = UISwitch()
//
//        self.musicToggle.setOn(musicStartsOn, animated: false)
//        self.soundsToggle.setOn(soundsStartOn, animated: false)
        
        self.bgImage = UIImage(named: "settings_background")!
        
//        addBackground()
        
        setupToggles()
        
        
    }
    
    private func addBackground() {
        self.view.frame.size = bgImage.size
        
        let imageView = UIImageView(frame: self.view.frame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = bgImage
        imageView.center = self.view.center
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
    private func setupToggles() {
        
        self.view.addSubview(musicToggle)
        
        musicToggle.translatesAutoresizingMaskIntoConstraints = false
        
        let musicConstraints = [
            musicToggle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 50),
            musicToggle.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 50)
        ]
        
        NSLayoutConstraint.activate(musicConstraints)
        
        self.view.addSubview(soundsToggle)
        
        soundsToggle.translatesAutoresizingMaskIntoConstraints = false
        
        let soundsConstraints = [
            soundsToggle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 50),
            soundsToggle.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50)
        ]
        
        NSLayoutConstraint.activate(soundsConstraints)
    }
}
