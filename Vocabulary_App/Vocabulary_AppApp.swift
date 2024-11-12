import SwiftUI

@main
struct Vocabulary_AppApp: App {
    
    var network = Network()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(network)
        }
    }
}
