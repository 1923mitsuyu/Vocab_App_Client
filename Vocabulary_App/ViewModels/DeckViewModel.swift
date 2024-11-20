import Foundation
import SwiftUI

class DeckWordViewModel : ObservableObject {
    
    @Published var decks: [Deck] = sampleDecks
    @Published var words: [Word] = sampleWords
    
    // Filter words based on the selected deck
    func filterWords(for deckId: Int, in wordList: [Word]) -> [Word] {
        return wordList.filter { $0.deckId == deckId }
    }
    
    func removeBrackets(_ string: String) -> String {
        let pattern = "\\{\\{(.+?)\\}\\}"
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
               return string 
           }
        let range = NSRange(location: 0, length: string.utf16.count)
        
        let cleanedString = regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "$1")
        
        return cleanedString
    }
 
    func checkIfNameExists (_ name: String, fetchedDecks: [Deck]) -> Bool {
        for deck in fetchedDecks {
            if deck.name == name {
                return true
            }
        }
        return false
    }
    
    func checkIfWordExists (_ targetWord: String) -> Bool {

        for word in words {
            let wordInDeck = word.word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let targetNewWord = targetWord.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if wordInDeck == targetNewWord { return true }
        }
        return false
    }
        
    func customiseButtonColour(correctTimes: Int) -> Color {
        switch correctTimes {
        case 0:
            return .black
        case 1...10:
            return .gray
        case 11...20:
            return .blue
        case 21...30:
            return .cyan
        case 31...40:
            return .purple
        case 41...50:
            return .orange
        case 51...60:
            return .yellow
        case 61...70:
            return .indigo
        case 71...80:
            return .mint
        case 81...90:
            return .black
        case 91...100:
            return .red
        default:
            return .clear
        }
    }

    
}
