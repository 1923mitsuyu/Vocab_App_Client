import SwiftUI

// TO DO LIST
// 1. Users turn to the next page to see more decks (pagination)
// 2. Users can tick off boxes that shows up when tapping one of the words in the list and then, they can delete the selected words
// 3. Users can sort the list of decks by date added or in alphabetical order, in either ascending or descending order.
// 4. Users can drag and drop the deck to change the order of the decks.

struct WordListView: View {

    let deck: Deck
    @State private var isWordInputActive = false
    
    var body: some View {
        NavigationStack {
            List(deck.words) { word in
                NavigationLink(destination: WordDetailView(word: word)) {
                    Text(word.word)
                        .fontWeight(.semibold)
                }
            }
            .navigationTitle("All Words")
            .background(.blue.gradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Jump to the page to create a deck
                        isWordInputActive = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .foregroundStyle(.white)
                    .padding(.trailing,10)
                    .navigationDestination(isPresented: $isWordInputActive) { NavigationParentView() }
                }
            }
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    WordListView(deck:  Deck(name: "Sample Deck1", words: [
        Word(word: "Procrastinate", definition: "後回しにする", example: "I procrastinated my assignments, but I finished them in time.", translation: "私は課題を後回しにした。"),
        Word(word: "Ubiquitous", definition: "どこにでもある", example: "Smartphones are ubiquitous nowadays.", translation: "スマホは至る所にある")
    ], listOrder: 0))
}
