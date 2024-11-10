import Foundation

class DeckViewModel : ObservableObject {
    
    @Published var decks: [Deck] = sampleDecks
    @Published var emptyDecks: [Deck] = []
    
    func fetchDecks () {
        updateDecksOrder()
        objectWillChange.send()
    }
    
    func updateDecksOrder () {
        for (index, _) in decks.enumerated() {
            decks[index].listOrder = index
        }
        // Notify SwiftUI of changes (not necessary unless needed explicitly)
        objectWillChange.send()
    }
    
    func checkIfNameExists (_ name: String) -> Bool {
        for deck in decks {
            if deck.name == name {
                return true
            }
        }
        return false
    }
    
    func checkIfWordExists (_ targetWord: String) -> Bool {
        for deck in decks {
            for word in deck.words {
                if word.word == targetWord {
                    return true
                }
            }
        }
        return false
    }
}
