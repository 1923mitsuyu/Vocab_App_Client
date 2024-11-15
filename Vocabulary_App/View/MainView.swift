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
        NavigationStack {
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
                        Label("Account", systemImage: "person.crop.circle")
                    }
            }
            .navigationBarBackButtonHidden()
            .accentColor(.black)
        }
    }
}

#Preview {
    MainView()
}
