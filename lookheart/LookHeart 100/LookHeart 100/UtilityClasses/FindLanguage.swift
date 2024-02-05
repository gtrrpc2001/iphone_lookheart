import Foundation

class FindLanguage {
    static let shared = FindLanguage()
    
    var language:String = ""
    
    func findLanguage() {
        let locale = Locale.current
        if let languageCode = locale.languageCode {
            language = languageCode
        }
    }
    
    func getLanguge() -> String? {
        if language.isEmpty {
            return nil
        }
        return language
    }
}
