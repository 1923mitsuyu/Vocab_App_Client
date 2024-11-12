import SwiftUI

struct MainView: View {
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        TabView {
            StudyHomeView()
                .tabItem {
                    Label("Study", systemImage: "brain.head.profile")
                }
            
            DeckListView()
                .tabItem {
                    Label("Deck", systemImage: "list.dash")
                }
    
            SettingView()
                .tabItem {
                    Label("Setting", systemImage: "gearshape")
                }
        }
        .navigationBarBackButtonHidden()
        .accentColor(.black)
    }
}

#Preview {
    MainView()
}
