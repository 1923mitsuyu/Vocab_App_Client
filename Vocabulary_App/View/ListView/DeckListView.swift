import SwiftUI

// TO DO LIST (8/11)
// Users can edit the name of the deck when pushing and holding the row (PUT)
// Users can see the alert when they try to delete the deck
// Users can delete the deck by swiping the row (DELETE)
// Set the background colour to blue
// Create a tab (Deck, Study, Setting)

struct DeckListView: View {
    
    let decks = sampleDecks
    @State private var isCreateDeckActive = false
    
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Jump to the page to create a deck
                        isCreateDeckActive = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding(.trailing,10)
                    .navigationDestination(isPresented: $isCreateDeckActive) { CreateDeckView() }
                    .navigationBarBackButtonHidden()
                }
            }
        }
    }
}

#Preview {
    DeckListView()
}
