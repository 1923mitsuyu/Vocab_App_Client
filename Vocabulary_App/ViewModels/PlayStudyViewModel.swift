import Foundation

class PlayStudyViewModel : ObservableObject {
    
    private var decks: [Deck] = sampleDecks
    @Published var progress: Double = 0.1
    @Published var writtenAnswer: String = ""
    @Published var selectionDeck = 0
    @Published var randomInt : Int = 0
    @Published var usedWordsIndex : [Int] = [0]
    
    func isRandomNumberUsed() -> Bool {
        if usedWordsIndex.contains(randomInt) {
            return true
        } else {
            return false
        }
    }
    
    func generateRandomQuestion() -> Int {
        
        let deckLength = decks.count
        
        // Generate a random integer
        randomInt = Int.random(in: 0..<deckLength - 2)
        
        // Check if the integer has been already used
        while isRandomNumberUsed() == true {
            randomInt = Int.random(in: 0..<deckLength - 2)
        }
        
        // new integer
        return randomInt
    }
    
    // 2. Check if all words in the deck has been used : return Bool
    func checkIfAllWordsUsed() -> Bool {
        if usedWordsIndex.count == decks[selectionDeck].words.count {
            return true
        }
        else {
            return false
        }
    }
        
    func checkIfAnswerIsCorrect() -> Bool {
        
        let trimmedAnswer = writtenAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let correctAnswer = decks[selectionDeck].words[randomInt].word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        print(trimmedAnswer)
        print(correctAnswer)
        if trimmedAnswer == correctAnswer {
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
