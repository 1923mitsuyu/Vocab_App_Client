import SwiftUI

// TO DO LIST
// 1. Users can change their profiles (usernames, passwords, age, purposes of learning English and their level of English etc)
// 2. Users can recieve push notification (APNs（Apple Push Notification Service))

struct AccountView: View {
    
    @State private var isLoginViewActive : Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Account")
                    .font(.system(size: 27, weight: .semibold, design: .rounded))
                    .padding(.top, 20)
                    .padding(.bottom, -10)
                
                List {
                    Section {
                        NavigationLink("Profile", destination: ProfileView())
                    }
                    
                    Section {
                        NavigationLink("Setting", destination: SettingView())
                    }
                }
                .scrollContentBackground(.hidden)
                
                Button {
                    // Call a func to log off here
                    isLoginViewActive = true
                } label: {
                    Text("Log Out")
                }
                .frame(width:130, height:50)
                .foregroundStyle(.blue)
                .background(.white)
                .cornerRadius(10)
                
                Spacer().frame(height:40)
            }
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .background(.blue.gradient)
            .navigationDestination(isPresented: $isLoginViewActive) {
                LoginView()
            }
        }
    }
}

#Preview {
    AccountView()
}
