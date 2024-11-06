import SwiftUI

struct SignUp: View {
    
    @EnvironmentObject var network: Network
    @StateObject var viewModel = UserViewModel()
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var error: Error?
    @State private var activeAlert: ActiveAlert? = nil
    @State private var isLoginViewActive = false
    
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
                        // Call a function to create a new user
                        let newUser = User(id: 0, username: userName, password: password)
                        Task {
                            await viewModel.loadCreateUser(user: newUser)
                        }
                    }
                }, label: {
                    Text("Sign Up")
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
                    case .shortPassword:
                        return Alert(title:Text("Password should be at least 8 characters long"))
                    }
                }
                
                Spacer().frame(height: 30)
                
                HStack {
                    Text("Has already an account?")
                    Button {
                        isLoginViewActive = true
                    } label: {
                        Text("Log In")
                            .underline()
                    }
                    .foregroundStyle(.black)
                    .navigationDestination(isPresented: $isLoginViewActive) {
                        Login()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    SignUp()
        .environmentObject(Network())
}
