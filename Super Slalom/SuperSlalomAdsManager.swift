final class SuperSlalomAdsManager {
    public var gamesUntilAd: Int
    
    public static let shared = SuperSlalomAdsManager.init()
    
    private init() {
        gamesUntilAd = 3
    }
}
