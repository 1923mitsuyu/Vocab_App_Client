import SwiftUI

struct SettingView: View {
    
    @State private var reminderIsOn = false
    @State private var isHovering = false
    @Binding var selectedColor: Color
    let colors: [Color] = [.blue, .teal, .indigo, .green, .purple, .orange, .gray]
    
    var body: some View {
        VStack {
            
            Text("Setting")
                .font(.system(size: 27, weight: .semibold, design: .rounded))
                .padding(.top, 20)
                .padding(.bottom, -3)
            
            List {
                Section(header: Text("Background Color").font(.headline)){
                    HStack {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 33, height: 40)
                                .onTapGesture {
                                    selectedColor = color
                                }
                                .overlay(Circle().stroke(.white, lineWidth: 2))
                                .padding(5)
                        }
                    }
                }
                
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
        .background(selectedColor)
        .animation(.easeInOut, value: selectedColor)
    }
}

#Preview {
    SettingView(selectedColor: .constant(.blue))
}
