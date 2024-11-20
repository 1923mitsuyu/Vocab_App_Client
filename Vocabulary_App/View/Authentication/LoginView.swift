import SwiftUI

// TO DO LIST
// 1. Implement Google Authentication : Priority 2
// 2. Implement the function to reset passwords : Priority 3

struct LoginView: View {
    
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var error: Error?
    @State private var activeAlert: ActiveAlert? = nil
    @State private var isSignUpActive = false
    @State private var isMainViewActive = false
    @State private var isError : Bool = false
    @State private var errorMessage : String = "Sign Up Failed. Try Again."
    @State private var userId : Int = 0
    @FocusState var focus: Bool
    
    enum ActiveAlert: Identifiable {
        case emptyFields
        case invalidPassword
        
        var id: Int {
            switch self {
            case .emptyFields:
                return 1
            case .invalidPassword:
                return 2
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            GeometryReader { _ in
                VStack{
                    Text("Vocab!")
                        .font(.system(size: 60, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                        .padding(.bottom,30)
                    
                    TextField("Phone number, user name, or email address", text: $userName)
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
                    
                    Spacer().frame(height: 30)
                    
                    SecureField("Password",text: $password)
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
                    
                    Spacer().frame(height:20)
                    
                    if isError {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                    }
                    
                    Spacer().frame(height:15)
                    
                    Button(action: {
                        // Call a function to reset the password
                        print("Reset the password")
                    }) {
                        Text("Forgot your password? Tap here!")
                            .foregroundStyle(.black)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .underline()
                            .padding(.bottom,15)
                    }
                    
                    Button(action: {
                        // Check if either of the values (username and password) is empty
                        if userName.isEmpty || password.isEmpty {
                            activeAlert = .emptyFields
                        }
                        else {
                            Task {
                                do {
                                    // Call a func to authenticate the users
                                    let user = try await AuthService.shared.login(username: userName, password: password)
                                    
                                    // Navigate to the Home page
                                    isMainViewActive = true
                                    
                                    // Assing the user id to pass the value to the home page
                                    userId = user.id
                                    
                                    print("user id: \(userId)")
                                    
                                } catch {
                                    isError = true
                                    print("Login failed with error: \(error.localizedDescription)")
                                }
                            }
                        }
                    }, label: {
                        Text("Login")
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
                        case .invalidPassword:
                            return Alert(title:Text("Invalid password"))
                        }
                    }
                    .navigationDestination(isPresented: $isMainViewActive) { MainView(userId: $userId) }
                    
                    Spacer().frame(height: 30)
                    
                    HStack {
                        Text("Don't have an account?")
                            .foregroundStyle(.black)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                        Button {
                            isSignUpActive = true
                        } label: {
                            Text("Sign Up")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .underline()
                        }
                        .foregroundStyle(.black)
                        .navigationDestination(isPresented: $isSignUpActive) { SignUpView() }
                    }
                    
                    HStack {
                        Divider()
                            .frame(maxWidth: .infinity, maxHeight: 1)
                            .background(Color.black)
                        
                        Text("OR")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 8)
                        
                        Divider()
                            .frame(maxWidth: .infinity, maxHeight: 1)
                            .background(Color.black)
                    }
                    .padding(.horizontal)
                    
                    Text("Login with Google Account")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                        .padding(.top)
                    
                    Spacer().frame(height:110)
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
    LoginView()
}



