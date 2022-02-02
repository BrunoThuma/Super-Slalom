import SpriteKit

enum SlalomAnimationFrame: String {
    case left
}

enum SlalomType: String {
    case blue = "blueflag"
    case red = "pinkflag"
    
    var left: String {
        return self.rawValue + "_left"
    }

    var right: String {
        return self.rawValue + "_right"
    }
}
