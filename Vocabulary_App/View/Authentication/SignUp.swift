import SwiftUI

// TO DO LIST
// 1. Implement password validation check : Priority 2
// 2. Display the error messages underneath the text field : Priority 5

struct SignUp: View {
    
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var error: Error?
    @State private var activeAlert: ActiveAlert? = nil
    @State private var isLoginViewActive = false
    @FocusState var focus: Bool
    
    enum ActiveAlert: Identifiable {
        case emptyFields
        case shortPassword
        
        var id: Int {
            switch self {
            case .emptyFields:
                return 1
            case .shortPassword:
                return 2
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { _ in
                VStack{
                    Text("Vocab!")
                        .font(.system(size: 60, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                        .padding(.bottom,30)
                    
                    TextField("Phone number, user name, or email address", text: $userName)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .padding()
                        .background(.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .padding(.horizontal)
                        .onChange(of: password) {
                            print("\(password) is entered")
                        }
                        .focused(self.$focus)
                    
                    Spacer().frame(height: 30)
                    
                    SecureField("Password",text: $password)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .padding()
                        .background(.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .padding(.horizontal)
                        .onChange(of: password) {
                            print("\(password) is entered")
                        }
                        .focused(self.$focus)
                    
                    Spacer().frame(height:30)
                    
                    Button(action: {
                        // Check if either of the values (username and password) is empty
                        if userName.isEmpty || password.isEmpty {
                            activeAlert = .emptyFields
                        }
                        else if password.count < 8 {
                            activeAlert = .shortPassword
                        }
                        else {
                            Task {
                                do {
                                    let user = try await AuthService.shared.signUp(username: userName, password: password)
                                    print("User info: \(user)")
                                    
                                    // Jump to Login view
                                    isLoginViewActive = true
                                } catch {
                                    print("Sign-up failed with error: \(error.localizedDescription)")
                                    // Set an appropriate error state or show an alert
                                }
                            }
                        }
                    }, label: {
                        Text("Sign Up")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .frame(width: UIScreen.main.bounds.size.width / 6 * 3,height: UIScreen.main.bounds.size.width / 17 * 1)
                    })
                    .disabled(userName.isEmpty || password.isEmpty)
                    .padding()
                    .foregroundStyle(.black)
                    .background(userName.isEmpty || password.isEmpty ? .gray : .white)
                    .cornerRadius(20)
                    .alert(item: $activeAlert) { alert in
                        switch alert {
                        case .emptyFields:
                            return Alert(title: Text("User name or password is empty."))
                        case .shortPassword:
                            return Alert(title:Text("Password should be at least 8 characters long"))
                        }
                    }
                    
                    Spacer().frame(height: 30)
                    
                    HStack {
                        Text("Has already an account?")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                        Button {
                            isLoginViewActive = true
                        } label: {
                            Text("Log In")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .underline()
                        }
                        .foregroundStyle(.black)
                        .navigationDestination(isPresented: $isLoginViewActive) {
                            Login()
                        }
                    }
                    
                    Spacer().frame(height: 150)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.blue.gradient)
                .navigationBarBackButtonHidden()
                .onTapGesture {
                    self.focus = false
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

#Preview {
    SignUp()
}
