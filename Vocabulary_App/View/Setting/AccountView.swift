import SwiftUI

// TO DO LIST
// 1. Users can change their profiles (usernames, passwords, age, purposes of learning English and their level of English etc)
// 2. Users can recieve push notification (APNs（Apple Push Notification Service))
// 3. Users can change the colour of the app (eg. red, green, blue, yellow)

struct AccountView: View {
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
                        NavigationLink("Notification", destination: NotificationView())
                    }
                    
                    Section {
                        NavigationLink("Setting", destination: SettingView())
                    }
                }
                .scrollContentBackground(.hidden)
                
                Button {
                    // Call a func to log off here
                } label: {
                    Text("Log Off")
                }
                .frame(width:130, height:50)
                .foregroundStyle(.white)
                .background(.cyan)
                .cornerRadius(10)
                
                Spacer().frame(height:40)
            }
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .background(.blue.gradient)
        }
    }
}

#Preview {
    AccountView()
}
