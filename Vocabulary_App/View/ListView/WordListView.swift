import SwiftUI

// TO DO LIST
// Implement a pagination for increased number of words
// Check boxes show up when tapping one of the words in the list
// Then, the delete button shows up at the bottom

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
    ]))
}
