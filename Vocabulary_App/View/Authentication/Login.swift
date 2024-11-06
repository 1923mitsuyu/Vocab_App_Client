import SwiftUI

struct Login: View {
    
    @EnvironmentObject var network: Network
    @StateObject var viewModel = UserViewModel()
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var error: Error?
    @State private var activeAlert: ActiveAlert? = nil
    @State private var isSignUpActive = false
    
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
            VStack{
                Text("Vocab!")
                    .font(. system(size: 60))
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .padding(.bottom,30)
                
                TextField("Phone number, user name, or email address", text: $userName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .padding(.horizontal)
                    .onChange(of: password) {
                        print("\(password) is entered")
                    }
                
                Spacer().frame(height: 30)
                
                SecureField("Password",text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .padding(.horizontal)
                    .onChange(of: password) {
                        print("\(password) is entered")
                    }
                
                Button(action: {
                    // Call a function to reset the password
                    print("Reset the password")
                }) {
                    Text("Forgot your password? Tap here!")
                        .underline()
                        .foregroundStyle(.black)
                        .padding(15)
                }
                
                Button(action: {
                    // Check if either of the values (username and password) is empty
                    if userName.isEmpty || password.isEmpty {
                        activeAlert = .emptyFields
                    }
                    else {
                        // Call a function to authenticate users
                        print("Authenticate the user")
                        Task {
                            await viewModel.loadGetUsers()
                        }
                    }
                }, label: {
                    Text("Login")
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.size.width / 6 * 3,height: UIScreen.main.bounds.size.width / 17 * 1)
                })
                .padding()
                .foregroundStyle(Color.white)
                .background(Color.black)
                .cornerRadius(20)
                .alert(item: $activeAlert) { alert in
                    switch alert {
                    case .emptyFields:
                        return Alert(title: Text("User name or password is empty."))
                    case .invalidPassword:
                        return Alert(title:Text("Invalid password"))
                    }
                }
                
                Spacer().frame(height: 30)
                
                HStack {
                    Text("Don't have an account?")
                    Button {
                        isSignUpActive = true
                    } label: {
                        Text("Sign Up")
                            .underline()
                    }
                    .foregroundStyle(.black)
                    .navigationDestination(isPresented: $isSignUpActive) { SignUp() }
                }
            
                HStack {
                    Divider()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .background(Color.black)
                    
                    Text("OR")
                        .padding(.horizontal, 8)
                        .foregroundStyle(.black)
                    
                    Divider()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .background(Color.black)
                }
                .padding(.horizontal)
                
                Text("Login with Google Account")
                    .padding(.top)
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
            .navigationBarBackButtonHidden()
        }
    }
}
#Preview {
    Login()
        .environmentObject(Network())
}
