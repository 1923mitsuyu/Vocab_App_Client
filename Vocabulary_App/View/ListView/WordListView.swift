import SwiftUI

struct WordListView: View {
    
    let deck: Deck
    
    var body: some View {
        NavigationStack {
            List(deck.words) { word in
                NavigationLink(destination: WordDetailView(word: word)) {
                    Text(word.word)
                        .fontWeight(.semibold)
                }
            }
            .navigationTitle("All Words")
        }
    }
}

#Preview {
    WordListView(deck:  Deck(name: "Sample Deck1", words: [
        Word(word: "Procrastinate", definition: "後回しにする", example: "I procrastinated my assignments.", translation: "私は課題を後回しにした。"),
        Word(word: "Ubiquitous", definition: "どこにでもある", example: "Smartphones are ubiquitous nowadays.", translation: "スマホは至る所にある")
    ]))
}
