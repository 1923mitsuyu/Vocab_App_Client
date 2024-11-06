import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    private var network = Network()
    @Published var isUserCreated: Bool = false
    
    func loadGetUsers() async {
        do {
            let users = try await network.getUsers()
            DispatchQueue.main.async {
                self.users = users
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func loadCreateUser(user: User) async {
        do {
            let createdUsers = try await network.createUsers(user: user)
            DispatchQueue.main.async {
                self.users = createdUsers
                self.isUserCreated = true
         }
        } catch {
            print("Error: \(error)")
        }
    }
    
}
