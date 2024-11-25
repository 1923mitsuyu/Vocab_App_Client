import SwiftUI

struct PlayStudyView: View {
    
    @ObservedObject var viewModel: PlayStudyViewModel
    @State private var selectedTab: Int = 1
    @State var randomNum : Int = 0
    @State var translation : String = ""
    @State private var isStudyHomeViewActive: Bool = false
    @State private var isResultViewActive: Bool = false
    @State private var isAnswerCorrect: Bool = false
    @State private var showAlert : Bool = false
    @State private var showPopup : Bool = false
    @State private var progress : Double = 0.00
    @State private var moveToNewWord : Bool = false
    @State private var modifiedExample : String = ""
    @State private var isAlertActive : Bool = false
    @State private var selectedDeckId : Int = 0
    @State private var correctAnswer : String = ""
    @State private var updatedCorrectTimes : Int = 0
    @State private var currentWordId : Int = 0
    @Binding var fetchedWords : [Word]
    @Binding var selectedDeck: Int
    @Binding var selectedColor: Color
    @Binding var userId : Int
    @Binding var fetchedDecks: [Deck]
    @FocusState var focus: Bool
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Spacer().frame(height: 10)
                
                // Progress Bar
                HStack{
                    Button {
                        isStudyHomeViewActive = true
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
                    .navigationDestination(isPresented: $isStudyHomeViewActive) {
                        MainView(userId: $userId, selectedTab: $selectedTab)
                    }
                    
                    Spacer().frame(width:20)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 300, height: 15)
                        
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: CGFloat(progress) * 3, height: 20)
                    }
                    .cornerRadius(10)
                    .frame(width: 320)
                    
                }
                .padding(.bottom,5)
                .padding(.trailing,10)
                
                Text("Complete the sentence")
                    .font(.system(size: 23, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 5)
                    .padding(.leading, 17)
                
                // Question with a blank to fill in
                VStack {
                    ScrollView {
                        if !fetchedWords.isEmpty {
                            Text(modifiedExample)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Text("No words in the deck for now")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                        }
                    }
                    .frame(maxHeight: 60) // ScrollViewの最大高さを指定
                }
                .padding(.leading, 20)
                .padding(.trailing, 10)
                .padding(.vertical, 15)
                .frame(maxWidth: 370, alignment: .leading)
                .background(.white)
                .cornerRadius(10)
                .fixedSize(horizontal: false, vertical: true)
                
                // Japanese Translation as a hint
                VStack {
                    Text("日本語訳:")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .frame(maxWidth: 360, alignment: .leading)
                        .padding(.top,10)
                    
                    ScrollView {
                        if !fetchedWords.isEmpty {
                            Text(translation)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .padding(.top,2)
                                .frame(maxWidth: 360, maxHeight: 100, alignment: .leading)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Text("No words in the deck for now")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                        }
                    }
                    .frame(maxHeight: 40)
                }
                
                Spacer().frame(height: 15)
                
                TextField("Write your answer here!", text: $viewModel.writtenAnswer)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding()
                    .background(Color.white)
                    .frame(width:300)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                    .padding(.horizontal)
                    .padding(.top,10)
                    .padding(.bottom,30)
                    .focused(self.$focus)
                    .keyboardType(.alphabet)
                    .disabled(showPopup)
                
                Button {
                    isAnswerCorrect = false
                    
                    // Check if the inputted answer is correct
                    isAnswerCorrect = viewModel.checkIfAnswerIsCorrect(selectedDeck, wordsList: fetchedWords, randomNum: randomNum)
                    
                    // When the answer is correct
                    if isAnswerCorrect {
                        // Increment the correct times count
                        fetchedWords[randomNum].correctTimes += 1
                        currentWordId = fetchedWords[randomNum].id
                        showPopup = true
                        // Dismiss the keyboard
                        self.focus = false
                    }
                    // When the answer is incorrect
                    else {
                        // Assign the word into the array
                        viewModel.wrongWordsIndex.append(randomNum)
                        // Show the pop up and hide the check button
                        showPopup = true
                        // Dismiss the keyboard
                        self.focus = false
                        
                        print("The wrong words are:")
                        for index in viewModel.wrongWordsIndex {
                            print("\(fetchedWords[index].word)")
                        }
                    }
                } label: {
                    Text("Check")
                        .font(.system(size: 23, weight: .semibold, design: .rounded))
                        .frame(width: 300, height:25)
                    
                }
                .disabled(viewModel.writtenAnswer.isEmpty)
                .padding()
                .foregroundStyle(viewModel.writtenAnswer.isEmpty ? .white : .blue)
                .background(viewModel.writtenAnswer.isEmpty ? .gray.opacity(0.8) : .white)
                .cornerRadius(20)
                
                Spacer()
            }
            .sheet(isPresented: $showPopup) {
                CustomSheetView(viewModel: viewModel, correctAnswer: $correctAnswer, fetchedWords: $fetchedWords, selectedDeck: $selectedDeck, selectedColor: $selectedColor, userId: $userId, fetchedDecks: $fetchedDecks, isAnswerCorrect: $isAnswerCorrect, isResultViewActive: $isResultViewActive, randomNum: $randomNum, progress: $progress, modifiedExample: $modifiedExample, translation: $translation, onDismiss: {
                    withAnimation {
                        showPopup = false
                    }
                })
                .interactiveDismissDisabled(true)
                .presentationDetents([.fraction(0.35)])
                .presentationDragIndicator(.hidden)
            }
            .onAppear {
                Task {
                    do {
                        // Check if the selected deck is empty
                        if fetchedWords.isEmpty {
                            isAlertActive = true
                            return
                        }
                        
                        // Generate the very first random number
                        randomNum = try await viewModel.generateRandomQuestion(wordsList: fetchedWords)
                        
                        if !fetchedWords.isEmpty {
                            // Generate a sentence with a blank for questions
                            let example = fetchedWords[randomNum].example
                            modifiedExample = viewModel.hideTargetWordInExample(example)
                            translation = fetchedWords[randomNum].translation
                            print("question: \(fetchedWords[randomNum].example)")
                            print("translation: \(fetchedWords[randomNum].translation)")
                            
                            correctAnswer = viewModel.extractWordFromBrackets(example: fetchedWords[randomNum].example) ?? "No matched word"
                            
                        } else {
                            print("Error in wordList: No words found")
                        }
                        
                    } catch {
                        print("Error filtering words: \(error.localizedDescription)")
                    }
                }
            }
            .alert(isPresented: $isAlertActive) {
                Alert(title: Text("Error"), message: Text("The target deck is empty. Please add words to the deck."), dismissButton: .default(Text("OK")) {
                    isStudyHomeViewActive = true
                })
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
            .navigationDestination(isPresented: $isResultViewActive) {
                ResultView(viewModel: PlayStudyViewModel(), viewModel2: DeckWordViewModel(), fetchedWords: $fetchedWords, selectedDeck: $selectedDeck, wrongWordIndex: $viewModel.wrongWordsIndex, selectedColor: $selectedColor, userId: $userId, fetchedDecks: $fetchedDecks)
            }
        }
        .navigationBarBackButtonHidden()
        .animation(.easeInOut(duration: 0.3), value: showPopup)
    }
}

#Preview {
    // Create a sample instance of PlayStudyViewModel with a sample deck index
    let sampleViewModel = PlayStudyViewModel()
    let mockDecks = [
            Deck(id: 1, name: "Deck 1", deckOrder: 1, userId: 1),
            Deck(id: 2, name: "Deck 2", deckOrder: 2, userId: 1)
        ]
    
    let mockWords = [    Word(id: 0, word: "Apple", definition: "りんご", example: "I eat an {{apple}} every morning but I did not eat it this morning. I just wanted to eat something different.", translation: "私は毎朝リンゴを食べます。", correctTimes: 0, word_order: 1, deckId: sampleDecks[0].id)]
    
    // Pass the sample ViewModel and selectedDeck binding to the preview
    PlayStudyView(viewModel: sampleViewModel, fetchedWords: .constant(mockWords), selectedDeck: .constant(0), selectedColor: .constant(.teal), userId: .constant(1), fetchedDecks: .constant(mockDecks))
}

struct CustomSheetView: View {

    @ObservedObject var viewModel: PlayStudyViewModel
    @Binding var correctAnswer: String
    @Binding var fetchedWords : [Word]
    @Binding var selectedDeck: Int
    @Binding var selectedColor: Color
    @Binding var userId : Int
    @Binding var fetchedDecks: [Deck]
    @Binding var isAnswerCorrect: Bool
    @Binding var isResultViewActive: Bool
    @Binding var randomNum : Int
    @Binding var progress : Double
    @Binding var modifiedExample : String
    @Binding var translation : String
    var onDismiss: () -> Void
    
    var body: some View {
        // When the answer is correct
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
                    // Assign the new integer to the array
                    viewModel.usedWordsIndex.append(randomNum)
                    
                    // Check if all the words in the deck have been used
                    if viewModel.checkIfAllWordsUsed(wordsList: fetchedWords) {
                        print("Finished all the words in the deck")
                        // Calculate the progress percentage
                        progress = viewModel.calculateProgress(selectedDeck, wordsList: fetchedWords)
                        
                        // Wait for one second and jump to the result view
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            // Remove the sheet
                            onDismiss()
                            // Navigate to the Result View
                            isResultViewActive = true
                        }
                    }
                    else {
                        for index in viewModel.usedWordsIndex {
                            print("The used word's index is: \(index)")
                        }
                        
                        // Remove the text in the text field
                        viewModel.resetTextField()
                        
                        Task {
                            do {
                                // Generate a new integer for the next question
                                randomNum = try await viewModel.generateRandomQuestion(wordsList: fetchedWords)
                                
                                if !fetchedWords.isEmpty {
                                    // Generate a sentence with a blank for questions
                                    let example = fetchedWords[randomNum].example
                                    // example : I borrowed a book from the library
                                    modifiedExample = viewModel.hideTargetWordInExample(example)
                                    translation = fetchedWords[randomNum].translation
                                    
                                    correctAnswer = viewModel.extractWordFromBrackets(example: fetchedWords[randomNum].example) ?? "No matched word"
                                    
                                    // Remove the sheet
                                    onDismiss()
                                    
                                } else {
                                    print("Error in wordList: No words found")
                                }
                                
                            } catch {
                                print("Error in generateRandomQuestion: \(error)")
                            }
                            // Calculate the progress percentage
                            progress = viewModel.calculateProgress(selectedDeck, wordsList: fetchedWords)
                            
                        }
                    }
                } label: {
                    Text("Continue")
                        .font(.system(size: 23, weight: .semibold, design: .rounded))
                        .frame(maxWidth: 200, maxHeight: 60)
                        .background(.white)
                        .cornerRadius(20)
                }
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green.opacity(0.9))
        }
        // When the answer is incorrect
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
                .padding(.vertical, 15)
                
                HStack {
                    Text("Correct Answer:")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    Text(correctAnswer) // here
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
                .padding(.bottom,35)
                
                Button {
                    // Remove the text in the text field
                    viewModel.resetTextField()
                    
                    Task {
                        do {
                            // Generate a new integer for the next question
                            randomNum = try await viewModel.generateRandomQuestion(wordsList: fetchedWords)
                            
                            if !fetchedWords.isEmpty {
                                // Generate a sentence with a blank for questions
                                let example = fetchedWords[randomNum].example
                                // example : I borrowed a book from the library
                                modifiedExample = viewModel.hideTargetWordInExample(example)
                                translation = fetchedWords[randomNum].translation
                                
                                correctAnswer = viewModel.extractWordFromBrackets(example: fetchedWords[randomNum].example) ?? "No matched word"
                                
                                // Remove the sheet
                                onDismiss()
                                
                            } else {
                                print("Error in wordList: No words found")
                            }
                            
                        } catch {
                            print("Error in generating random question: \(error.localizedDescription)")
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red.opacity(0.9))
        }
    }
}
