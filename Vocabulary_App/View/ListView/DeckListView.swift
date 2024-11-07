import SwiftUI

struct DeckListView: View {
    let decks = sampleDecks
    
    var body: some View {
           NavigationStack {
               List(decks) { deck in
                   NavigationLink(destination: WordListView(deck: deck)) {
                       Text(deck.name)
                           .fontWeight(.bold)
                           .padding(.vertical, 4)
                   }
               }
               .navigationTitle("All Decks")
           }
       }
   }
#Preview {
    DeckListView()
}
