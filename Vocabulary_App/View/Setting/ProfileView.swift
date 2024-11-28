import SwiftUI

struct ProfileView: View {
    
    @State private var userName : String = "Ikufumi Mitsuyu"
    @State private var emailAddress : String = "ikufumi665@gmail.com"
    @State private var mobileNumber : String = "0455577649"
    @State private var dateOfBirth: Date = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.date(from: "15/07/1998") ?? Date()
        }()
    private var formattedDateOfBirth: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: dateOfBirth)
        }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Name")) {
                        Text(userName)
                    }
                    
                    Section(header: Text("Email Address")) {
                        Text(emailAddress)
                    }
                    
                    Section(header: Text("Mobile Number")) {
                        Text(mobileNumber)
                    }
                    
                    Section(header: Text("Date of birth")) {
                        Text(formattedDateOfBirth)
                    }
                }
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .scrollContentBackground(.hidden)
            }
            .background(.blue.gradient)
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    ProfileView()
}
