import Foundation

class DeckViewModel : ObservableObject {
    
    @Published var decks: [Deck] = sampleDecks
    @Published var emptyDecks: [Deck] = []
        
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
