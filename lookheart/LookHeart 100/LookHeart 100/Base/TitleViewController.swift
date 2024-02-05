import Foundation
import UIKit

class TitleViewController: UIViewController {
    
    public let safeAreaView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSafeAreaView()
        setSafeAreaView()
        setupCustomTitleView()
        
    }
    
    // Safe Area 설정
    func setSafeAreaView() {
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                safeAreaView.topAnchor.constraint(equalTo: guide.topAnchor),
                safeAreaView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([   // iOS 11 미만에서는 topLayoutGuide와 bottomLayoutGuide를 사용
                safeAreaView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                safeAreaView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            ])
        }
    }
    
    func initSafeAreaView(){
        view.backgroundColor = .white
        view.addSubview(safeAreaView)
        
        NSLayoutConstraint.activate([
            safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // Custom Title View 설정
    func setupCustomTitleView() {
        let customTitleView = TitleView()
        let customTitleViewItem = UIBarButtonItem(customView: customTitleView)
        self.navigationItem.leftBarButtonItem = customTitleViewItem
    }
    
    func getSafeAreaView() -> UIView {
        return safeAreaView
    }
}
