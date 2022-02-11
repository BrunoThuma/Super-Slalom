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
    
    var fallenFlag1: String {
        return self.rawValue + "hit1"
    }
    
    var fallenFlag2: String {
        return self.rawValue + "hit2"
    }
    
    var fallenFlag3: String {
        return self.rawValue + "hit3"
    }
    
    var fallenFlag4: String {
        return self.rawValue + "hit4"
    }
    
    var fallenFlag5: String {
        return self.rawValue + "hit5"
    }
    
    var fallenFlag6: String {
        return self.rawValue + "hit6"
    }
    
    var fallenFlag7: String {
        return self.rawValue + "hit7"
    }
    
    var fallenFlag8: String {
        return self.rawValue + "hit8"
    }
}
