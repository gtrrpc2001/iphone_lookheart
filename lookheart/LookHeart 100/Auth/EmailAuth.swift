//import FirebaseAuth
//import LookheartPackage
//
//
//class EmailAuth {
//    
//    static let shared = EmailAuth()
//    
//    private let actionCodeSettings = ActionCodeSettings()
//    private var authFlag = false
//    
//    private init() {
//
//    }
//    
//    func sendEmail(view: UIView, email: String) {
//        actionCodeSettings.url = URL(string: "https://lookheart-912c7.firebaseapp.com/?email=\(email)")
//        actionCodeSettings.handleCodeInApp = true
//        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
//        
//        Auth.auth().sendSignInLink(toEmail: email,
//                                   actionCodeSettings: actionCodeSettings) { error in
//        
//            if let error = error {
//                ToastHelper.shared.showToast(view.self, "send Email Error", withDuration: 1.0, delay: 1.0, bottomPosition: true)
//              print(error.localizedDescription)
//              return
//            } else {
//                print("Check your email for link")
//                NotificationManager.shared.authAlert()
//            }
//        }
//    }
//    
//    func setFlag() {
//        authFlag = true
//    }
//    func getFlag() -> Bool {
//        return authFlag
//    }
//}
