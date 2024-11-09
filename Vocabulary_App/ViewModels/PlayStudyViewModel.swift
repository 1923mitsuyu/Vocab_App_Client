import Foundation

class PlayStudyViewModel : ObservableObject {
    
    private var decks: [Deck] = sampleDecks
    @Published var progress: Double = 0.1
    @Published var writtenAnswer: String = ""
    var usedWords : [String] = []

    func generateRandomQuestion() -> Int {
        let deckLength = decks.count
        let randomInt = Int.random(in: 0..<deckLength)
        return randomInt
    }
    
    // 2. Check if all words in the deck has been used : return Bool
    func checkIfAllWordsUsed() -> Bool {
        // check the length of usedWords array is the same of that of the original deck
        return true
    }
    
    func checkIfAnswerIsCorrect() -> Bool {
        if writtenAnswer == decks[0].words[0].word {
            return true
        }
        else {
            return false
        }
    }
    
    // 4. Calculate the progress : return progress
    func calculateProgress() {
        
    }
    
    // 5. Reset the text field : return writtenAnswer
    func resetTextField() {
        writtenAnswer = ""
    }
}
