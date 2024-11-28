import SwiftUI

struct MainView: View {
    
    @State private var selectedDeck: Int = 0
    @Binding var userId : Int
    @Binding var selectedTab: Int
    
    init(userId: Binding<Int>, selectedTab: Binding<Int>) {
        self._userId = userId
        self._selectedTab = selectedTab
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                StudyHomeView(userId: $userId)
                    .tabItem {
                        Label("Study", systemImage: "brain.head.profile")
                    }
                    .tag(1)
                
                DeckListView(selectedDeck: selectedDeck, userId: $userId)
                    .tabItem {
                        Label("Deck", systemImage: "list.dash")
                    }
                    .tag(2)
                
                AccountView()
                    .tabItem {
                        Label("Account", systemImage: "person.crop.circle")
                    }
                    .tag(3)
            }
            .navigationBarBackButtonHidden()
            .accentColor(.black)
        }
    }
}

#Preview {
    MainView(userId: .constant(1), selectedTab: .constant(1))
}
