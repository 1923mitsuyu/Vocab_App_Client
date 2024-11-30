import Foundation

class PlayStudyViewModel : ObservableObject {
    
    @Published var writtenAnswer: String = ""
    @Published var selectionDeck = 0
    @Published var usedWordsIndex : [Int] = []
    @Published var wrongWordsIndex : [Int] = []
    @Published var arrangedWords: [String] = []
    @Published var tappedWordIndex: Int? = nil
    @Published var tappedWordsIndex : [Int] = []
    
    func sliceSuffleSentence(sentence : String) -> [String]{
        let trimmedSentence = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
        var array = trimmedSentence.components(separatedBy: " ")
        print("The splitted array before it gets shuffled: \(array)")
        array = array.shuffled()
        return array
    }
    
    func putArrayBackToString() -> String{
        return arrangedWords.joined(separator: " ")
    }
    
    func checkAnswer(userAnswer: String, modifiedExample: String) -> Bool{
        print("Checking ans.....")
        
        let userWords = userAnswer.split(separator: " ").map { String($0) }
        let correctWords = modifiedExample.split(separator: " ").map { String($0) }
        
        if userWords.count != correctWords.count {
            return false
        }
        
        for (userWord, correctWord) in zip(userWords, correctWords) {
            print("userWord: \(userWord), correctWord: \(correctWord)")
            if userWord != correctWord {
                return false
            }
        }
        
        return true
    }
    
    func storeTappedWordsIndex(index: Int){
        tappedWordsIndex.append(index)
        print("Tapped Words: \(tappedWordsIndex)")
    }
    
    // 単語をスペースに移動させる処理
    func moveWordToSpace(index: Int, options:[String]) {
        let word = options[index]
        arrangedWords.append(word)
        tappedWordIndex = index
        
        print("Chosen words: \(arrangedWords)")
        // 少し遅らせて選択をリセット
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tappedWordIndex = nil
        }
    }
    
    // 単語をスペースから外に移動させる処理
    func moveWordOutOfSpace(index: Int) {
        arrangedWords.remove(at: index)
        tappedWordsIndex.remove(at: index)
    }
    
    func calculateProgress(wordsList : [Word] )-> Double {
        let totalNumberOfWords = wordsList.count
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
                    return String(example[range]).lowercased()
                }
            }
        } catch {
            print("正規表現が無効です")
        }
        
        return nil  // 一致が見つからなかった場合
    }
    
    func isRandomNumberUsed(randomNum: Int) -> Bool {
        if usedWordsIndex.contains(randomNum) {
            return true
        } else {
            return false
        }
    }
    
    func generateRandomQuestion(wordsList : [Word]) async throws -> Int {
        
        let maxQuestion = wordsList.count
        
        print("Max Number: \(maxQuestion)")
        
        // Generate a random integer
        var randomNum = Int.random(in: 0..<maxQuestion)
        
        // Check if the integer has been already used
        while isRandomNumberUsed(randomNum: randomNum) == true {
            print("\(randomNum) has already been used so let's generate a new one.")
            randomNum = Int.random(in: 0..<maxQuestion)
        }
        
        print("The new random integer is \(randomNum).")
        
        // new integer
        return randomNum
    }
    

    func checkIfAllWordsUsed(wordsList : [Word]) -> Bool {
    
        if usedWordsIndex.count == wordsList.count {
            return true
        }
        else {
            return false
        }
    }
        
    func checkIfAnswerIsCorrect(_ chosenDeck : Int, wordsList : [Word], randomNum : Int ) -> Bool {
        
        print("Checking the answer...")
        
        let trimmedAnswer = writtenAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        print("The random int for checking ans: \(randomNum)")
        
        for word in wordsList {
            print("Word: \(word.word), Example: \(word.example)")
        }
            
        // 正しい単語を取得するために extractWordFromBrackets を呼び出す
        guard let correctAnswer = extractWordFromBrackets(example: wordsList[randomNum].example) else {
            print("Error in getting a correct answer.")
            return false
        }
        
        print("Written Answer:\(trimmedAnswer)")
        print("Correct Answer: \(correctAnswer)")
                
        if trimmedAnswer == correctAnswer {
            return true
        } else {
            return false
        }
    }
        
    func resetTextField() {
        writtenAnswer = ""
    }
}

