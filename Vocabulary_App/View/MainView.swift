import SwiftUI

struct MainView: View {
    
    @State private var selectedDeck: Int = 0
    
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
                
                DeckListView(selectedDeck: selectedDeck)
                    .tabItem {
                        Label("Deck", systemImage: "list.dash")
                    }
                
                AccountView()
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
