import SwiftUI

struct MainView: View {
    
    @StateObject var deckViewModel = DeckViewModel()
    @StateObject var playStudyViewModel = PlayStudyViewModel()
    
    init() {
        // Customize the unselected tab icon color
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        TabView {
            DeckListView(viewModel: DeckViewModel())
                .tabItem {
                    Label("Deck", systemImage: "list.dash")
                }
           
            StudyHomeView(viewModel: PlayStudyViewModel())
                .tabItem {
                    Label("Study", systemImage: "brain.head.profile")
                }
             
            SettingView()
                .tabItem {
                    Label("Setting", systemImage: "gearshape")
                }
        }
        .accentColor(.black)
    }
}

#Preview {
    MainView()
}
