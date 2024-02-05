//import Foundation
//
//class MailSlurpClient {
//    let apiKey = "0e2b436d7d521710af567d9ed53e824bc5bcddcf8b56b02498bf5ad28b479982"
//    let session = URLSession.shared
//
//    func sendEmail() {
//        let url = URL(string: "https://api.mailslurp.com/emails")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
//
//        let emailDetails: [String: Any] = [
//            "subject": "Test Email",
//            "body": "Test",
//            "to": ["rlawodnd4267@naver.com"],
//        ]
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: emailDetails, options: [])
//        request.httpBody = jsonData
//
//        let task = session.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error sending email: \(error)")
//                return
//            }
//            if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
//                print("Email sent successfully")
//            } else {
//                print("Failed to send email")
//            }
//        }
//        task.resume()
//    }
//}
