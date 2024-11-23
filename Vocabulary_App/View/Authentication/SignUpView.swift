import SwiftUI

// sample password : P@ssw0rd2024

// TO DO LIST
// 1. Show the error message "The user name has already existed" in the alert.

struct SignUpView: View {
    
    @ObservedObject var viewModel = AuthenticationViewModel()
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var error: Error?
    @State private var activeAlert: ActiveAlert? = nil
    @State private var isLoginViewActive = false
    @State private var errorMessage : [String] = []
    @State private var serverErrorMessage : String = ""
    @FocusState var focus: Bool
    
    enum ActiveAlert: Identifiable {
        case inValidPassword
        case serverError
        var id: Int {
            switch self {
            case .inValidPassword:
                return 1
            case .serverError:
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
                        .focused(self.$focus)
                    
                    Spacer().frame(height:20)
                    
                    Button(action: {
                        
                        // Validate the password
                        errorMessage = viewModel.validatePassword(password)
                        
                        if !errorMessage.isEmpty {
                            activeAlert = .inValidPassword
                        }
                        else if errorMessage.isEmpty {
                            Task {
                                do {
                                    let user = try await AuthService.shared.signUp(username: userName, password: password)
                                    print("User info: \(user)")
                                    
                                    // Jump to Login view
                                    isLoginViewActive = true
                                } catch {
                                    activeAlert = .serverError
                                    serverErrorMessage = "Sign-up failed. Please try again later."
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
                    .foregroundStyle(userName.isEmpty || password.isEmpty ? .white : .blue)
                    .background(userName.isEmpty || password.isEmpty ? .gray : .white)
                    .cornerRadius(20)
                    .alert(item: $activeAlert) { alert in
                        switch alert {
                        case .inValidPassword:
                            let errorMessages = errorMessage.joined(separator: "\n")
                            return Alert(title: Text("Invalid password"), message: Text(errorMessages))
                        case .serverError:
                            return Alert(title: Text(serverErrorMessage))
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
                            LoginView()
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
    SignUpView()
}




