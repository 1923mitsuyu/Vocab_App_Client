import Foundation

class PlayStudyViewModel : ObservableObject {
    
    @Published var decks: [Deck] = sampleDecks
    @Published var writtenAnswer: String = ""
    @Published var selectionDeck = 0
    @Published var randomInt : Int = 0
    @Published var usedWordsIndex : [Int] = []
    @Published var wrongWordsIndex : [Int] = []
    
    func calculateProgress(_ chosenDeck : Int )-> Double {
        let totalNumberOfWords = decks[chosenDeck].words.count
        let numberOfUsedWords = usedWordsIndex.count
        return totalNumberOfWords > 0 ? (Double(numberOfUsedWords) / Double(totalNumberOfWords) * 100) : 0
    }
    
    func hideTargetWordInExample(_ example: String) -> String {
        // 正規表現で {{}} 内の部分を見つける
        print("Trying to make a blank in \(example)")
        let regex = try! NSRegularExpression(pattern: "\\{\\{([^}]+)\\}\\}", options: [])
        let range = NSRange(location: 0, length: example.utf16.count)
            
        // マッチする部分を動的に処理
        var modifiedExample = example
        regex.enumerateMatches(in: example, options: [], range: range) { match, flags, stop in
            guard let matchRange = match?.range(at: 1) else { return }
            let word = (example as NSString).substring(with: matchRange)
            
            // 単語の長さに合わせたアンダースコアを生成
            let underscore = String(repeating: ".", count: word.count)
            
            // {{}} の部分をアンダースコアで置き換え
            modifiedExample = (modifiedExample as NSString).replacingCharacters(in: match!.range, with: underscore)
            
        }
        
        return modifiedExample
    }
    

    func extractWordFromBrackets(example: String) -> String? {
        // 正規表現パターン：{{}}内の単語を抽出
        let pattern = "\\{\\{(.*?)\\}\\}"
        
        do {
            // 正規表現を作成
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            
            // 文字列内で一致する部分を検索
            let range = NSRange(location: 0, length: example.utf16.count)
            if let match = regex.firstMatch(in: example, options: [], range: range) {
                // {{}}内の単語を抽出
                if let range = Range(match.range(at: 1), in: example) {
                    return String(example[range])  // 単語を返す
                }
            }
        } catch {
            print("正規表現が無効です")
        }
        
        return nil  // 一致が見つからなかった場合
    }
    
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
            print("\(randomInt) has already been used so let's generate a new one.")
            randomInt = Int.random(in: 0..<deckLength - 2)
        }
        
        print("The new random integer is \(randomInt).")
        
        // new integer
        return randomInt
    }
    

    func checkIfAllWordsUsed() -> Bool {
        
        print("Checking if all words have been used...")
        print("The num of used words is \(usedWordsIndex.count).")
        print("selected deck: \(selectionDeck)")
        print("words count : \(decks[selectionDeck].words.count)")
        
        if usedWordsIndex.count == decks[selectionDeck].words.count {
            return true
        }
        else {
            return false
        }
    }
        
    func checkIfAnswerIsCorrect(_ chosenDeck : Int ) -> Bool {
        
        let trimmedAnswer = writtenAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // 正しい単語を取得するために extractWordFromBrackets を呼び出す
        guard let correctAnswer = extractWordFromBrackets(example: decks[chosenDeck].words[randomInt].example) else {
            return false
        }
        
        print("written answer: \(trimmedAnswer)")
        print("correct answer: \(correctAnswer)")
        
        // 答えが正しいかどうかを比較
        if trimmedAnswer == correctAnswer {
            return true
        } else {
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

