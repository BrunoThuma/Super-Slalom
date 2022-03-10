import UIKit

class SettingsView: UIView {

    let bgImage: UIImage
    private var bgImageView: UIImageView!
    private let musicToggle, soundsToggle: UISwitch
    
    init(musicIsOn musicStartsOn: Bool, soundsAreOn soundsStartOn: Bool) {
        self.musicToggle = UISwitch()
        self.soundsToggle = UISwitch()
        
        self.musicToggle.setOn(musicStartsOn, animated: false)
        self.soundsToggle.setOn(soundsStartOn, animated: false)
        
        self.bgImage = UIImage(named: "settings_background")!
        
        super.init(frame: .zero)
        
        addBackground()
        
        setupToggles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func recalculateBackgroundConstraints() {
        let constraints = [
            bgImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bgImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        print("Jonas")
    }
    
    private func addBackground() {
        bgImageView = UIImageView(image: bgImage)
        
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = false
        bgImageView.image = bgImage
        bgImageView.center = self.center
        addSubview(bgImageView)
        sendSubviewToBack(bgImageView)
        
        recalculateBackgroundConstraints()
    }
    
    private func setupToggles() {
        
        self.addSubview(musicToggle)
        musicToggle.translatesAutoresizingMaskIntoConstraints = false
        musicToggle.clipsToBounds = true
        
        let musicConstraints = [
            musicToggle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 50),
            musicToggle.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 50)
        ]
        
        NSLayoutConstraint.activate(musicConstraints)
        
        self.addSubview(soundsToggle)
        soundsToggle.translatesAutoresizingMaskIntoConstraints = false
        soundsToggle.clipsToBounds = true
        
        let soundsConstraints = [
            soundsToggle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 50),
            soundsToggle.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50)
        ]
        
        NSLayoutConstraint.activate(soundsConstraints)
    }
}
