import UIKit

class SettingsView: UIView {

    let bgImage: UIImage
    private var bgImageView: UIImageView!
    private var soundsClosure, musicClosure: ((Bool) -> Void)?
    private let musicToggle, soundsToggle: UISwitch
    
    
    init(musicIsOn musicStartsOn: Bool, musicClosure: @escaping ((Bool) -> Void),
         soundsAreOn soundsStartOn: Bool, soundsClosure: @escaping ((Bool) -> Void)) {
        
        self.musicToggle = UISwitch()
        self.soundsToggle = UISwitch()
        
        self.musicToggle.setOn(musicStartsOn, animated: false)
        self.soundsToggle.setOn(soundsStartOn, animated: false)
        
        self.bgImage = UIImage(named: "settings_background")!
        
        self.musicClosure = musicClosure
        self.soundsClosure = soundsClosure
        
        super.init(frame: .zero)
        
        self.musicToggle.addTarget(self,
                                   action: #selector(musicSwitchDidChangeState),
                                   for: .valueChanged)
        self.soundsToggle.addTarget(self,
                                    action: #selector(soundsSwitchDidChangeState),
                                    for: .valueChanged)
        
        addBackground()
        
        setupToggles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func soundsSwitchDidChangeState() {
        print("soundsSwitchDidChangeState")
        soundsClosure!(soundsToggle.isOn)
    }
    
    @objc func musicSwitchDidChangeState() {
        print("musicSwitchDidChangeState")
        musicClosure!(musicToggle.isOn)
    }
    
    private func addBackground() {
        bgImageView = UIImageView(image: bgImage)
        
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = false
        bgImageView.image = bgImage
        bgImageView.center = self.center
        addSubview(bgImageView)
        sendSubviewToBack(bgImageView)
        
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        
        setupBackgroundConstraints()
    }
    
    
    func setupBackgroundConstraints() {
        let constraints = [
            bgImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bgImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    private func setupToggles() {
        
        self.addSubview(soundsToggle)
        soundsToggle.translatesAutoresizingMaskIntoConstraints = false
        soundsToggle.clipsToBounds = true
        
        let soundsConstraints = [
            soundsToggle.centerXAnchor.constraint(equalTo: self.centerXAnchor,
                                                  constant: 90),
            soundsToggle.centerYAnchor.constraint(equalTo: self.centerYAnchor,
                                                  constant: -20)
//            soundsToggle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            soundsToggle.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(soundsConstraints)
        
        self.addSubview(musicToggle)
        musicToggle.translatesAutoresizingMaskIntoConstraints = false
        musicToggle.clipsToBounds = true
        
        let musicConstraints = [
            musicToggle.centerXAnchor.constraint(equalTo: self.centerXAnchor,
                                                 constant: 90),
            musicToggle.centerYAnchor.constraint(equalTo: self.centerYAnchor,
                                                 constant: 90)
//            musicToggle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            musicToggle.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(musicConstraints)
        
        
    }
}
