import SwiftUI

struct MainView: View {
    
    init() {
        // Customize the unselected tab icon color
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
    }
    
    var body: some View {
        TabView {
            DeckListView()
                .tabItem {
                    Label("Deck", systemImage: "list.dash")
                        .foregroundColor(.green)
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
        .accentColor(.white)
    }
}

#Preview {
    MainView()
}
