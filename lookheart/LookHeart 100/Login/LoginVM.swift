//
//  LoginVM.swift
//  LOOKHEART 100
//
//  Created by KHJ on 2024/04/09.
//

import Foundation
import UIKit
import LookheartPackage

class LoginVM {
    private var loginModel = LoginModel(email: "", password: "")
    
    private var onLoginValidationFailed: ((String) -> Void)?
    private var onLoginValidationSucceeded: (() -> Void)?
    
    
    func setValidationHandlers(
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        self.onLoginValidationSucceeded = onSuccess
        self.onLoginValidationFailed = onFailure
    }
    
    
    func updateEmail(_ email: String) {
        loginModel.email = email
    }
    
    func updatePassword(_ password: String) {
        loginModel.password = password
    }
    
    
    func validateLogin(autoLogin: Bool, retryCount: Int = 0) {
        if !checkValid(isValid: loginModel.isValid()) { return }
        
        let appKey = defaults.string(forKey: appKey) ?? String(Int.random(in: 1000...9999))
        Task {
            let checkAppKey = await LoginService.shared.getAppKey(appKey, loginModel.email)
            
            switch checkAppKey {
            case .success:
                await checkLogin(autoLogin: autoLogin, key: appKey)
            case .failer:
                await postAppKey(autoLogin: autoLogin, key: appKey)
            case .notConnected:
                onLoginValidationFailed?("serverInternetError".localized())
            case .session:
                if retryCount < 3 {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    validateLogin(autoLogin: autoLogin, retryCount: retryCount + 1)
                } else {
                    onLoginValidationFailed?("againLater".localized())
                }
            default:
                onLoginValidationFailed?("againLater".localized())
            }
        }
    }
    
    
    private func checkLogin(autoLogin: Bool, key: String) async {
        let loginResponse = await LoginService.shared.loginTask(loginModel.email, loginModel.password)
        
        switch loginResponse {
        case .success:
            let _ = Keychain.shared.setString(loginModel.email, forKey: userEmailKey)
            defaults.set(key, forKey: appKey)
            defaults.set(autoLogin, forKey: authLoginKey)
            
            onLoginValidationSucceeded?()
        case .failer:
            onLoginValidationFailed?("incorrectlyLogin".localized())
        case .notConnected:
            onLoginValidationFailed?("serverInternetError".localized())
        default:
            onLoginValidationFailed?("againLater".localized())
        }
    }
    
    
    private func postAppKey(autoLogin: Bool, key: String) async {
        let appKeyResponse = await LoginService.shared.postAppKey(key, loginModel.email)
        
        switch appKeyResponse {
        case .success:
            await checkLogin(autoLogin: autoLogin, key: key)
        default:
            onLoginValidationFailed?("againLater".localized())
        }
    }
    
    
    private func checkValid(isValid: LoginModel.ValidationState) -> Bool {
        switch isValid {
        case .valid:
            return true
        case .invalidEmail:
            onLoginValidationFailed?("emailHelp".localized())
            return false
        case .invalidPassword:
            onLoginValidationFailed?("passwordHelp".localized())
            return false
        case .invalidEmailAndPassword:
            onLoginValidationFailed?("correctIdPwHelp".localized())
            return false
        }
    }
}
