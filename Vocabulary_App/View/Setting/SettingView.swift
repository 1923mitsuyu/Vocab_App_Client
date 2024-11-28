import SwiftUI

struct SettingView: View {
    
    @State private var reminderIsOn = false
    
    var body: some View {
        VStack {
            
            Text("Setting")
                .font(.system(size: 27, weight: .semibold, design: .rounded))
                .padding(.top, 20)
                .padding(.bottom, -3)
            
            List {
                                
                Section(header: Text("Reminder").font(.headline)){
                    HStack {
                        Text("Notification")
                            .font(.system(size: 23, weight: .semibold, design: .rounded))
                            .frame(width: 200)
                            .padding(.vertical,10)
                            .padding(.trailing,90)
            
                        Toggle("", isOn: $reminderIsOn)
                            .labelsHidden()
                            .padding(.leading,10)
                            .padding(.trailing,50)
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .frame(maxWidth:.infinity, maxHeight:.infinity)
        .background(.blue.gradient)
    }
}

#Preview {
    SettingView()
}

