
import SwiftUI

// TO DO LIST:
// 1. Check if the entered email address matches with the registered one.

struct ResetPasswordView: View {
    
    @State private var emailAddress : String = ""
    @State private var isActiveAlert : Bool = false
    @FocusState var focus: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer().frame(height: 30)
                
                Text("Password Reset")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .padding(.bottom,10)
                Text("You will receive an email with a link to reset your password.")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .padding(.bottom,20)
                
                TextField("Your email address here", text: $emailAddress)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .padding(.horizontal)
                    .focused(self.$focus)
                
                Button {
                    print("Tapped")
                    if emailAddress.isValidEmail {
                        print("Valid Email Adress")
                    } else {
                        print("Invalid Email Adress")
                        isActiveAlert = true
                    }
                } label: {
                    HStack {
                        Image(systemName: "envelope")
                        Text("Send")
                    }
                }
                .foregroundStyle(emailAddress.isEmpty ? .white : .blue)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .disabled(emailAddress.isEmpty)
                .frame(width:300, height:40)
                .background(emailAddress.isEmpty ? .gray : .white)
                .cornerRadius(10)
                .padding(.top,40)
                .alert(isPresented: $isActiveAlert) {
                    Alert(
                        title: Text("Invalid Email Format"),
                        message: Text("Please enter a valid email address (e.g., example@domain.com)."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
        }
    }
}

extension String {
    var isValidEmail: Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}

#Preview {
    ResetPasswordView()
}
