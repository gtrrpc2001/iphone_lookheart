import Foundation

let emailRegex = try? NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}$")
let passwordRegex = try? NSRegularExpression(pattern: "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{10,}$")
let nameRegex = try? NSRegularExpression(pattern: "^[^\\d\\W]+$")
let heightAndWeightRegex = try? NSRegularExpression(pattern: "^[0-9]{1,3}$")
let targetNumberRegex = try? NSRegularExpression(pattern: "^[0-9]{1,5}$")
let bedTimeRegex = try? NSRegularExpression(pattern: "^([0-9]|1[0-9]|2[0-4])$")
let phoneNumberRegex = try? NSRegularExpression(pattern: "^[0-9]{8,20}$")
let numberRegex = try! NSRegularExpression(pattern: "[0-9]+")
