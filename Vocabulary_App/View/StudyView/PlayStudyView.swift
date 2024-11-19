import SwiftUI

// TO DO LIST
// 1. Popupが出た時に、UIが動かないようにする

struct PlayStudyView: View {
    
    @ObservedObject var viewModel: PlayStudyViewModel
    @State var wordList : [Word] = []
    @State var randomNum : Int = 0
    @State var translation : String = ""
    @Binding var selectedDeck: Int
    @State private var isStudyHomeViewActive: Bool = false
    @State private var isResuktViewActive: Bool = false
    @State private var isAnswerCorrect: Bool = false
    @State private var showAlert : Bool = false
    @State private var showPopup : Bool = false
    @State private var progress : Double = 0.00
    @State private var moveToNewWord : Bool = false
    @State private var modifiedExample : String = ""
    @State private var isAlertActive : Bool = false
    @FocusState var focus: Bool
    @State private var correctAnswer : String = ""
    @Binding var selectedColor: Color

    var body: some View {
        
        NavigationStack {
            VStack {
                Spacer().frame(height: 10)
                
                HStack{
                    Button {
                        isStudyHomeViewActive = true
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
                    .navigationDestination(isPresented: $isStudyHomeViewActive) {
                        MainView()
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
                        if !wordList.isEmpty {
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
                        if !wordList.isEmpty {
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
                    
                if showPopup {
                    // When the answer is correct
                    if isAnswerCorrect {
                        VStack {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                    .font(.title)
                                
                                Text("Good Job!")
                                    .font(.system(size: 23, weight: .semibold, design: .rounded))
                            }
                            .frame(maxWidth: .infinity)
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .padding(.vertical, 20)
                            
                            Button {
                                // Assign the new integer to the array
                                viewModel.usedWordsIndex.append(randomNum)
                                
                                // Check if all the words in the deck have been used
                                if viewModel.checkIfAllWordsUsed(wordsList: wordList) {
                                    print("Finished all the words in the deck")
                                    // Calculate the progress percentage
                                    progress = viewModel.calculateProgress(selectedDeck, wordsList: wordList)
                                    // Wait for one second and jump to the result view
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                        isResuktViewActive = true
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
                                            randomNum = try await viewModel.generateRandomQuestion(wordsList: wordList)
                                            
                                            if !wordList.isEmpty {
                                                // Generate a sentence with a blank for questions
                                                let example = wordList[randomNum].example
                                                // example : I borrowed a book from the library
                                                modifiedExample = viewModel.hideTargetWordInExample(example)
                                                translation = wordList[randomNum].translation
                                                
                                                correctAnswer = viewModel.extractWordFromBrackets(example: wordList[randomNum].example) ?? "No matched word"
                                                
                                            } else {
                                                print("Error in wordList: No words found")
                                            }
                                            
                                        } catch {
                                            print("Error in generateRandomQuestion: \(error)")
                                        }
                                        // Calculate the progress percentage
                                        progress = viewModel.calculateProgress(selectedDeck, wordsList: wordList)
                                        
                                    }
                                    
                                    withAnimation {
                                        showPopup = false
                                    }
                                    
                                    isAnswerCorrect = false
                                }
                            } label: {
                                Text("Continue")
                                    .font(.system(size: 23, weight: .semibold, design: .rounded))
                                    .frame(maxWidth: 200, maxHeight: 60)
                                    .background(.white)
                                    .cornerRadius(20)
                            }
                            .padding(.bottom, 20)
                            .navigationDestination(isPresented: $isResuktViewActive) {
                                ResultView(viewModel: PlayStudyViewModel(), viewModel2: DeckWordViewModel(), wordList: $wordList, selectedDeck: $selectedDeck, wrongWordIndex: $viewModel.wrongWordsIndex, selectedColor: $selectedColor)
                            }
                            
                        }
                        .background(Color.green.opacity(0.9))
                        .transition(
                            .asymmetric(
                                insertion: .opacity.combined(with: .move(edge: .bottom)),
                                removal: .opacity.combined(with: .move(edge: .bottom))
                            )
                        )
                        .animation(.easeInOut(duration: 0.3), value: showPopup)
                        .zIndex(1)
                        
                    }
                     // When the answer is incorrect
                     else {
                         VStack {
                             HStack {
                                 Image(systemName: "xmark.circle")
                                     .font(.title)
                                 
                                 Text("Good Try!")
                                     .font(.system(size: 23, weight: .semibold, design: .rounded))
                             }
                             .frame(maxWidth: .infinity)
                             .cornerRadius(15)
                             .padding(.horizontal)
                             .padding(.vertical, 20)
                                       
                             HStack {
                                 Text("Correct Answer:")
                                     .font(.system(size: 20, weight: .semibold, design: .rounded))
                                 Text(correctAnswer) // here
                                     .font(.system(size: 20, weight: .semibold, design: .rounded))
                             }
                                 
                             Button {
                                 // Remove the text in the text field
                                 viewModel.resetTextField()
                                 
                                 Task {
                                     do {
                                         // Generate a new integer for the next question
                                         randomNum = try await viewModel.generateRandomQuestion(wordsList: wordList)
                                         
                                         if !wordList.isEmpty {
                                             // Generate a sentence with a blank for questions
                                             let example = wordList[randomNum].example
                                             // example : I borrowed a book from the library
                                             modifiedExample = viewModel.hideTargetWordInExample(example)
                                             translation = wordList[randomNum].translation
                                             
                                             correctAnswer = viewModel.extractWordFromBrackets(example: wordList[randomNum].example) ?? "No matched word"
                                             
                                   
                                         } else {
                                             print("Error in wordList: No words found")
                                         }
                                         
                                     } catch {
                                         print("Error in generating random question: \(error.localizedDescription)")
                                     }
                                 }
                                  
                                 withAnimation {
                                     showPopup = false
                                 }
                                 
                                 isAnswerCorrect = false
                                 
                             } label: {
                                 Text("Got it")
                                     .font(.system(size: 23, weight: .semibold, design: .rounded))
                                     .frame(maxWidth: 200, maxHeight: 60)
                                     .background(.white)
                                     .cornerRadius(20)
                             }
                             .padding(.bottom, 20)
                             .navigationDestination(isPresented: $isResuktViewActive) {
                                 ResultView(viewModel: PlayStudyViewModel(), viewModel2: DeckWordViewModel(), wordList: $wordList, selectedDeck: $selectedDeck, wrongWordIndex: $viewModel.wrongWordsIndex, selectedColor: $selectedColor)
                             }
                             
                         }
                         .background(Color.red.opacity(0.9))
                         .transition(
                                 .asymmetric(
                                     insertion: .opacity.combined(with: .move(edge: .bottom)),
                                     removal: .opacity.combined(with: .move(edge: .bottom))
                                 )
                             )
                         .zIndex(1)
                     }
                }
                else {
                    Button {
                        // Check if the inputted answer is correct
                        isAnswerCorrect = viewModel.checkIfAnswerIsCorrect(selectedDeck, wordsList: wordList, randomNum: randomNum)
                        
                        // Dismiss the keyboard
                        self.focus = false
                        
                        // When the answer is correct
                        if isAnswerCorrect {
                           // Increment correct time
                            wordList[randomNum].correctTimes += 1
                            
                            // Show the pop up and hide the check button
                            withAnimation {
                                showPopup = true
                            }
                        }
                        // When the answer is incorrect
                        else {
                            // Assign the word into the array
                            viewModel.wrongWordsIndex.append(randomNum)
                            
                            // Show the pop up and hide the check button
                            withAnimation {
                                showPopup = true
                            }
                            
                            print("The wrong words are:")
                            for index in viewModel.wrongWordsIndex {
                                print("\(wordList[index].word)")
                            }
                        }
                    } label: {
                        Text("Check")
                            .font(.system(size: 23, weight: .semibold, design: .rounded))
                            .frame(width: 300, height:25)
                        
                    }
                    .disabled(viewModel.writtenAnswer.isEmpty)
                    .padding()
                    .foregroundStyle(.black)
                    .background(viewModel.writtenAnswer.isEmpty ? .gray.opacity(0.8) : .white)
                    .cornerRadius(20)
                }
                
                Spacer()
            }
            .onAppear {
                    
                Task {
                    do {
                        // Filter the list of words based on the selected deck
                        wordList = try await viewModel.filterWords(for: viewModel.decks[selectedDeck].id, in: viewModel.words)
                        
                        // Check if the target deck is empty
                        if wordList.isEmpty {
                            isAlertActive = true
                            return
                        }
                        
                        randomNum = try await viewModel.generateRandomQuestion(wordsList: wordList)
                        
                        print("Random int: \(randomNum)")
                     
                      
                        if !wordList.isEmpty {
                            // Generate a sentence with a blank for questions
                            let example = wordList[randomNum].example
                            modifiedExample = viewModel.hideTargetWordInExample(example)
                            translation = wordList[randomNum].translation
                            print("question: \(wordList[randomNum].example)")
                            print("translation: \(wordList[randomNum].translation)")
                            
                        correctAnswer = viewModel.extractWordFromBrackets(example: wordList[randomNum].example) ?? "No matched word"
                            
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
            .background(selectedColor)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
    }

}
#Preview {
    // Create a sample instance of PlayStudyViewModel with a sample deck index
    let sampleViewModel = PlayStudyViewModel()
    // Pass the sample ViewModel and selectedDeck binding to the preview
    PlayStudyView(viewModel: sampleViewModel, selectedDeck: .constant(0), selectedColor: .constant(.teal))
}
