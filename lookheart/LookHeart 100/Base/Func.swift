import Foundation
import AVFAudio
import UIKit

// 최상위 뷰 찾는 함수
func getTopViewController() -> UIViewController? {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
        return nil
    }

    guard let rootViewController = windowScene.windows.filter({ $0.isKeyWindow }).first?.rootViewController else {
        return nil
    }

    return getVisibleViewController(rootViewController)
}

private func getVisibleViewController(_ vc: UIViewController?) -> UIViewController? {
    if let navigationController = vc as? UINavigationController {
        return getVisibleViewController(navigationController.visibleViewController)
    } else if let tabBarController = vc as? UITabBarController {
        return getVisibleViewController(tabBarController.selectedViewController)
    } else if let presentedViewController = vc?.presentedViewController {
        return getVisibleViewController(presentedViewController)
    } else {
        return vc
    }
}

class CustomTextField: UITextField {
    // textField 터치 범위 설정
    private let touchAreaInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let hitTestRect = bounds.inset(by: touchAreaInsets)
        
        return hitTestRect.contains(point)
    }
}
