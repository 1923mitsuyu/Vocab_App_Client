import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            DeckListView()
                .tabItem {
                    Label("Deck", systemImage: "list.dash")
                }
            
            StudyHomeView()
                .tabItem {
                    Label("Study", systemImage: "brain.head.profile")
                }
            
            SettingView()
                .tabItem {
                    Label("Setting", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    MainView()
}
