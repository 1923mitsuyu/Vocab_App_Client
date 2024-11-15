import SwiftUI

// TO DO LIST
// 1. Make a base of UI
// 2. Users can change their profiles (usernames, passwords, age, purposes of learning English and their level of English etc)
// 3. Users can turn on and off reminders (push notification)
// 4. Users can change the colour of the app (eg. red, green, blue, yellow)

struct SettingView: View {
    var body: some View {
        VStack {
            Text("Account")
                .font(.system(size: 27, weight: .semibold, design: .rounded))
                .padding(.top, 10)
                .padding(.bottom, -10)
            
            List {
                Section {
                    Text("Profile")
                    
                }
                
                Section {
                    Text("Notification")
                }
                
                Section {
                    Text("Setting")
                }
            }
            .scrollContentBackground(.hidden)
            
            Button {
                // Call a func to log off here
            } label: {
                Text("Log Off")
            }
            .frame(width:130, height:50)
            .background(.white)
            .cornerRadius(10)
            
            Spacer().frame(height:10)
        }
        .font(.system(size: 20, weight: .semibold, design: .rounded))
        .background(.blue.gradient)
    }
}

#Preview {
    SettingView()
}
