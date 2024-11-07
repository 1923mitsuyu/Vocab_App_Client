import SwiftUI

// TO DO LIST (8/11)
// Users can edit the name of the deck when pushing and holding the row (PUT)
// Users can delete the deck by swiping the row (DELETE)

struct DeckListView: View {
    
    let decks = sampleDecks
    @State private var isCreateDeckActive = false
    @State private var isPressed = false
    @State private var isAlertVisible = false
    @State private var deckToDelete: Deck?
        
    var body: some View {
        NavigationStack {
            List(decks) { deck in
                NavigationLink(destination: WordListView(deck: deck)) {
                    Text(deck.name)
                        .fontWeight(.bold)
                        .padding(.vertical, 4)
                      
                }
                .gesture(
                    LongPressGesture(minimumDuration: 1.0)
                        .onChanged { _ in
                            isPressed = true
                        }
                        .onEnded { _ in
                            isPressed = false
                            deckToDelete = deck
                            isAlertVisible = true
                        }
                )
            }
            .background(.blue.gradient)
            .scrollContentBackground(.hidden)
            .navigationTitle("All Decks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isCreateDeckActive = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding(.trailing,10)
                    .navigationDestination(isPresented: $isCreateDeckActive) { CreateDeckView() }
                    .navigationBarBackButtonHidden()
                }
            }
            .alert(isPresented: $isAlertVisible) {
                Alert(
                    title: Text("Delete Deck?"),
                    message: Text("Are you sure you want to delete this deck?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let deckToDelete = deckToDelete {
                            deleteDeck(deckToDelete)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

func deleteDeck(_ deck: Deck) {
    print("Deleted deck: \(deck.name)")
}

#Preview {
    DeckListView()
}
