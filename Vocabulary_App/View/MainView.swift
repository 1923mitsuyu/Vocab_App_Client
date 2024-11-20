import SwiftUI

struct MainView: View {
    
    @State private var selectedDeck: Int = 0
    @State private var selectedColor : Color = .cyan
    @Binding var userId : Int
    
    init(userId: Binding<Int>) {
        self._userId = userId
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            TabView {
                StudyHomeView(selectedColor: $selectedColor, userId: $userId)
                    .tabItem {
                        Label("Study", systemImage: "brain.head.profile")
                    }
                
                DeckListView(selectedDeck: selectedDeck,selectedColor: $selectedColor, userId: $userId)
                    .tabItem {
                        Label("Deck", systemImage: "list.dash")
                    }
                
                AccountView(selectedColor: $selectedColor)
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
    MainView(userId: .constant(1))
}
