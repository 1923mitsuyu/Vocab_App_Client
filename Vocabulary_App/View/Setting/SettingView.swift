import SwiftUI

struct SettingView: View {
    
    @State private var reminderIsOn = false
    @State private var isHovering = false
    
    var body: some View {
        VStack {
            
            Text("Notification")
                .font(.system(size: 27, weight: .semibold, design: .rounded))
                .padding(.top, 20)
                .padding(.bottom, -3)
            
            HStack {
                Image(systemName: "questionmark.app.fill")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .padding(.trailing,5)
                    .onTapGesture {
                        isHovering.toggle()
                    }
                    .overlay {
                        if isHovering {
                            Text("You will receive regular notifications to remind you to study!")
                                .padding(10)
                                .background(Color.black.opacity(0.75))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .transition(.opacity)
                                .frame(width: 250)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading, 100)
                                .padding(.top,200)
                                .offset(y: -30)
                        }
                    }
            
                Text("Recieve notification")
                    .padding(.top, 30)
                    .padding(.bottom,10)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                
                Toggle("", isOn: $reminderIsOn)
                    .labelsHidden()
                    .padding(.top, 20)
                    .padding(.leading,10)
                
            }
            Spacer()
        }
        .frame(maxWidth:.infinity, maxHeight:.infinity)
        .background(.blue.gradient)
    
    }
}

#Preview {
    SettingView()
}
