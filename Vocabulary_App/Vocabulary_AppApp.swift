import SwiftUI

@main
struct Vocabulary_AppApp: App {
    var network = Network()
    var body: some Scene {
        WindowGroup {
            DeckListView()
                .environmentObject(network)
        }
    }
}
