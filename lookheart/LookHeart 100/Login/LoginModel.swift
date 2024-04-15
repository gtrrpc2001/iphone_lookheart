//
//  LoginModel.swift
//  LOOKHEART 100
//
//  Created by KHJ on 2024/04/09.
//

import Foundation

struct LoginModel {
    static let emailRegex = try? NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}$")
    static let passwordRegex = try? NSRegularExpression(pattern: "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{10,}$")
    
    
    enum ValidationState {
        case valid
        case invalidEmail
        case invalidPassword
        case invalidEmailAndPassword
    }
    
    
    var email: String
    var password: String
    
    
    func isValid() -> ValidationState {
        let emailValid = isEmailValid()
        let passwordValid = isPasswordValid()
        
        if emailValid && passwordValid {
            return .valid
        } else if !emailValid && passwordValid {
            return .invalidEmail
        } else if emailValid && !passwordValid {
            return .invalidPassword
        } else {
            return .invalidEmailAndPassword
        }
    }
    
    private func isEmailValid() -> Bool {
        return LoginModel.emailRegex?.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
    }
    
    private func isPasswordValid() -> Bool {
        return LoginModel.passwordRegex?.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.count)) != nil
    }
}
