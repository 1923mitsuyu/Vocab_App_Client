import SwiftUI

// TO DO LIST
// 1. Fix the bug of removing all the same word from the choice.
// 2. Fix the bug of having empty box in the choices
// 3. The long sentence wil be cut off in the red sheet 
// 4. Move all funcs into viewModel
// 5. 次の問題生成 -> 別パターンの質問に遷移を直す

struct WordRearrangementView: View {
    
    @ObservedObject var viewModel: PlayStudyViewModel
    @ObservedObject var viewModel2: DeckWordViewModel
    @State private var options : [String] = []
    @State private var word : String = ""
    @State private var arrangedWords: [String] = []
    @State private var tappedWordIndex: Int? = nil
    @State private var joinedSentence : String = ""
    @Binding var progress : Double
    @Binding var modifiedExample : String
    @Binding var isAnswerCorrect : Bool
    @Binding var showPopup : Bool
    @Binding var translation : String
    @Binding var randomNum: Int
    @Binding var isResultViewActive: Bool
    @Binding var fetchedWords : [Word]
    @Binding var selectedDeck: Int
    @Binding var userId : Int
    @Binding var fetchedDecks: [Deck]
    @Binding var isFillInTheBlank : Bool
    
    let itemsPerRow = 4
    var onDismiss: () -> Void
    
    func sliceSuffleSentence(sentence : String) -> [String]{
        let array = sentence.components(separatedBy: " ").shuffled()
        return array
    }
    
    func putArrayBackToString(array : [String]) -> String{
        return array.joined(separator: " ")
    }
    
    func checkAnswer(userAnswer: String) -> Bool{
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
        
    var body: some View {
        
        let columns = [
            GridItem(.adaptive(minimum: 100)),
        ]
        
        NavigationStack {
            VStack{
            
                VStack(alignment: .leading) {
                    Text("- 日本語訳 - ")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom,5)
                    
                    Text(translation)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                }
                .padding(.leading,15)
                .padding(.bottom,20)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        let minNumLines = 2
                        let nLines = max(minNumLines, (arrangedWords.count + itemsPerRow - 1) / itemsPerRow)
                        ForEach(0..<nLines, id: \.self) { row in
                            HStack(spacing: 5) {
                                ForEach(0..<itemsPerRow, id: \.self) { column in
                                    let index = row * itemsPerRow + column
                                    ZStack {
                                        if index < arrangedWords.count {
                                            let targetWord = arrangedWords[index]
                                            Text(targetWord)
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(Rectangle().fill(Color.green.opacity(0.8)))
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    moveWordOutOfSpace(index: index)
                                                    print("arranged words: \(arrangedWords)")
                                                }
                                        }
                                    }
                                    .frame(height: 50)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                }
                
                Spacer().frame(height: 30)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(options.indices, id: \.self) { index in
                            if !arrangedWords.contains(options[index]) {
                                Text(options[index])
                                    .padding()
                                    .frame(minWidth: 100)
                                    .background(Rectangle().fill(Color.green.opacity(0.8)))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        if !options.isEmpty{
                                            moveWordToSpace(index: index)
                                            print("arranged words: \(arrangedWords)")
                                        }
                                    }
                                    .offset(y: tappedWordIndex == index ? -50 : 0)
                                    .animation(.spring(), value: tappedWordIndex)
                            }
                            else {
                                Text("")
                                    .padding()
                                    .frame(minWidth: 100)
                                    .background(Rectangle().fill(Color.gray.opacity(0.8)))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer().frame(height: 30)
                
                Button {
                    // Join each split word into one string
                    joinedSentence = putArrayBackToString(array: arrangedWords)
                    print("The joined Sentecd:\(joinedSentence)")
                    // Check if the answer is correct
                    isAnswerCorrect = checkAnswer(userAnswer: joinedSentence)
                    print("Correct Answer?: \(isAnswerCorrect)")
                    
                    if isAnswerCorrect {
                        viewModel.usedWordsIndex.append(randomNum)
                        print("The used index:\(viewModel.usedWordsIndex)")
                        fetchedWords[randomNum].correctTimes += 1
                        progress = viewModel.calculateProgress(wordsList: fetchedWords)
                        
                    } else {
                        viewModel.wrongWordsIndex.append(randomNum)
                        print("The wrong word index:\(viewModel.wrongWordsIndex)")
                    }
                    
                    // Show the pop-up
                    showPopup = true
                    
                } label: {
                    Text("Check")
                        .font(.system(size: 23, weight: .semibold, design: .rounded))
                        .frame(width: 300, height:25)
                }
                .disabled(arrangedWords.isEmpty)
                .padding()
                .foregroundStyle(arrangedWords.isEmpty ? .white : .blue)
                .background(arrangedWords.isEmpty ? .gray.opacity(0.8) : .white)
                .cornerRadius(20)
                
            }
            .navigationDestination(isPresented: $isResultViewActive) {
                ResultView(viewModel: viewModel, viewModel2: viewModel2, fetchedWords: $fetchedWords, selectedDeck: $selectedDeck, wrongWordIndex: $viewModel.wrongWordsIndex, userId: $userId, fetchedDecks: $fetchedDecks)
            }
            .onAppear {
                Task {
                    if fetchedWords.isEmpty {
                        // isAlertActive = true
                        return
                    }
                    
                    do {
                        // Generate a random int to get ready for the first random question
                        randomNum = try await viewModel.generateRandomQuestion(wordsList: fetchedWords)
                        
                        // Remove the bracket and set the first question
                        let original_example = fetchedWords[randomNum].example
                        modifiedExample = viewModel2.removeBrackets(original_example)
                       
                        translation = fetchedWords[randomNum].translation
                        
                        // Split the sentence into the array
                        options = sliceSuffleSentence(sentence: modifiedExample)
                        print("Splitted Sentence: \(options)")
                        
                    } catch {
                        print("Error in fetching words: \(error.localizedDescription)")
                    }
                }
            }
            .sheet(isPresented: $showPopup) {
                if isAnswerCorrect {
                    VStack {
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .font(.title)
                            
                            Text("Good Job!")
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                        
                        Button {
                            if viewModel.checkIfAllWordsUsed(wordsList: fetchedWords) {
                                print("Finished all the words in the deck")
                                                
                                // Wait for one second and jump to the result view
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                    // Remove the sheet
                                    onDismiss()
                                    // Navigate to the Result View
                                    isResultViewActive = true
                                }
                                
                            } else {
                                Task {
                                    do {
                                        // Reset the answer
                                        arrangedWords = []
                                        
                                        // Generate a new word
                                        randomNum = try await viewModel.generateRandomQuestion(wordsList: fetchedWords)
                                        
                                        // Remove the bracket and set the first question
                                        let original_example = fetchedWords[randomNum].example
                                        modifiedExample = viewModel2.removeBrackets(original_example)
                                    
                                        translation = fetchedWords[randomNum].translation
                                        
                                        // Split the sentence into the array
                                        options = sliceSuffleSentence(sentence: modifiedExample)
                                        
                                        // Remove the sheet
                                        onDismiss()
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            isFillInTheBlank.toggle()
                                        }
                                        
                                    } catch {
                                        print("Error in generating a new word: \(error.localizedDescription)")
                                    }
                                }
                            }
                        } label: {
                            Text("Continue")
                                .font(.system(size: 23, weight: .semibold, design: .rounded))
                                .frame(maxWidth: 200, maxHeight: 60)
                                .background(.white)
                                .cornerRadius(20)
                        }
                    }
                    .interactiveDismissDisabled(true)
                    .presentationDetents([.fraction(0.35)])
                    .presentationDragIndicator(.hidden)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.green.opacity(0.9))
                }
                else {
                    VStack {
                        HStack {
                            Image(systemName: "xmark.circle")
                                .font(.title)
                            
                            Text("Good Try!")
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                        
                        VStack {
                            Text("Correct Answer")
                                .padding(.bottom,10)
                            Text(modifiedExample)
                        }
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding(.bottom,35)
                        
                        Button {
                            Task {
                                do {
                                    // Reset the answer
                                    arrangedWords = []
                                    
                                    // Generate a new word
                                    randomNum = try await viewModel.generateRandomQuestion(wordsList: fetchedWords)
                                    
                                    // Remove the bracket and set the first question
                                    let original_example = fetchedWords[randomNum].example
                                    modifiedExample = viewModel2.removeBrackets(original_example)
                                    
                                    translation = fetchedWords[randomNum].translation
                                    
                                    // Split the sentence into the array
                                    options = sliceSuffleSentence(sentence: modifiedExample)
                                    
                                    // Remove the sheet
                                    onDismiss()
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        isFillInTheBlank.toggle()
                                    }
                                    
                                } catch {
                                    print("Error in generating a new word: \(error.localizedDescription)")
                                }
                            }
                            
                        } label: {
                            Text("Got it")
                                .font(.system(size: 23, weight: .semibold, design: .rounded))
                                .frame(maxWidth: 200, maxHeight: 60)
                                .background(.white)
                                .cornerRadius(20)
                        }
                    }
                    .interactiveDismissDisabled(true)
                    .presentationDetents([.fraction(0.35)])
                    .presentationDragIndicator(.hidden)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.red.opacity(0.9))
                }
            }
            .padding(.bottom,30)
        }
    }
    
    // 単語をスペースに移動する処理
    private func moveWordToSpace(index: Int) {
        word = options[index]
        arrangedWords.append(word)
        tappedWordIndex = index
        
        // 少し遅らせて選択をリセット
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            tappedWordIndex = nil
        }
    }
    
    private func moveWordOutOfSpace(index: Int) {
        arrangedWords.remove(at: index)
    }
}

#Preview {
    
    let mockDecks = [
        Deck(id: 1, name: "Deck 1", deckOrder: 1, userId: 1),
        Deck(id: 2, name: "Deck 2", deckOrder: 2, userId: 1)
    ]
    
    let mockWords = [Word(id: 0, word: "Apple", definition: "りんご", example: "I eat an {{apple}} every morning but I did not eat it this morning. I just wanted to eat something different.", translation: "私は毎朝リンゴを食べます。", correctTimes: 0, word_order: 1, deckId: mockDecks[0].id)]
    
    WordRearrangementView(
        viewModel: PlayStudyViewModel(),
        viewModel2: DeckWordViewModel(),
        progress: .constant(1),
        modifiedExample: .constant("Hello"),
        isAnswerCorrect: .constant(false),
        showPopup: .constant(false),
        translation: .constant("私は毎朝リンゴを食べます。"),
        randomNum: .constant(0),
        isResultViewActive: .constant(false),
        fetchedWords: .constant(mockWords),
        selectedDeck: .constant(1),
        userId: .constant(1),
        fetchedDecks:.constant(mockDecks),
        isFillInTheBlank: .constant(false),
        onDismiss: {}
    )
}



