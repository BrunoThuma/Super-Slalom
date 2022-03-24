import UIKit
protocol GameCenterDelegate: AnyObject {
    func presentGameCenterLogin(_ vc: UIViewController, animated: Bool, completion: @escaping () -> Void)
}
