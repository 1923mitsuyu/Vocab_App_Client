import SwiftUI

// TO DO LIST
// 1. Users can change their profiles (usernames, passwords, age, purposes of learning English and their level of English etc)
// 2. Users can recieve push notification (APNs（Apple Push Notification Service))

struct AccountView: View {
    
    @State private var isLoginViewActive : Bool = false
    @Binding var selectedColor: Color
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Account")
                    .font(.system(size: 27, weight: .semibold, design: .rounded))
                    .padding(.top, 20)
                    .padding(.bottom, -10)
                
                List {
                    Section {
                        NavigationLink("Profile", destination: ProfileView(selectedColor: $selectedColor))
                    }
                    
                    Section {
                        NavigationLink("Setting", destination: SettingView(selectedColor: $selectedColor))
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
                .foregroundStyle(.white)
                .background(.blue)
                .cornerRadius(10)
                
                Spacer().frame(height:40)
            }
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .background(selectedColor)
            .navigationDestination(isPresented: $isLoginViewActive) {
                LoginView()
            }
        }
    }
}

#Preview {
    AccountView(selectedColor: .constant(.teal))
}
