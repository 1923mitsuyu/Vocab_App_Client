import Foundation

class AuthenticationViewModel : ObservableObject {
    
    func validatePassword(_ password: String) -> [String] {
        var errors: [String] = []

        if password.count < 8 {
            errors.append("・8文字以上で入力してください。")
        }
        if password.range(of: "[A-Z]", options: .regularExpression) == nil {
            errors.append("・1つの大文字を含めてください。")
        }
        if password.range(of: "[a-z]", options: .regularExpression) == nil {
            errors.append("・1つの小文字を含めてください。")
        }
        if password.range(of: "\\d", options: .regularExpression) == nil {
            errors.append("・1つの数字を含めてください。")
        }
        if password.range(of: "[^A-Za-z0-9]", options: .regularExpression) == nil {
            errors.append("・1つの特殊文字を含めてください。")
        }

        return errors
    }
}
