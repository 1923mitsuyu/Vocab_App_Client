import Foundation

class DeckViewModel : ObservableObject {
    
    @Published var decks: [Deck] = sampleDecks
 
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
                let wordInDeck = word.word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                let targetNewWord = targetWord.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                if wordInDeck == targetNewWord { return true }
            }
        }
        return false
    }
    
    func addWordToDeck(_ word: String, _ definition: String, _ example: String, _ translation: String, _ deckName: String) {
        if let index = decks.firstIndex(where: { $0.name == deckName }) {
            decks[index].words.append(
                Word(word: word, definition: definition, example: example, translation: translation, wordOrder: decks[index].words.count, deckId: 1)
            )
        }
    }
}
