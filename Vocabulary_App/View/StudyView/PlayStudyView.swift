import SwiftUI

// TO DO LIST
// 1. Show the pop-up (Good Job [green]vs Good try[red]) with a right answer in it : Priority 4
// 2. Users tap "continue" button to proceed : Priority 5
// 3. Users will see the same questions if they have answered incorrectly : Priority 5
// 4. Make the uderline of the target word blue : Priority 1

struct PlayStudyView: View {
    
    @ObservedObject var viewModel: PlayStudyViewModel
    @Binding var selectedDeck: Int
    @State private var isStudyHomeViewActive: Bool = false
    @State private var isResuktViewActive: Bool = false
    @State private var isAnswerCorrect: Bool = false
    @State private var totalPoints: Int = 0
    @State private var showAlert : Bool = false
    @State private var showPopup : Bool = false
    @State private var progress : Double = 0.00
    @State private var moveToNewWord : Bool = false
    @FocusState var focus: Bool
    
    var body: some View {
        
        // Generate a sentence with a blank for questions
        let example = viewModel.decks[selectedDeck].words[viewModel.randomInt].example
        let modifiedExample = viewModel.hideTargetWordInExample(example)
       
        NavigationStack {
            VStack {
                Spacer().frame(height: 30)
                
                HStack{
                    Button {
                        isStudyHomeViewActive = true
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
                    .navigationDestination(isPresented: $isStudyHomeViewActive) {
                        StudyHomeView(viewModel: PlayStudyViewModel())
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
                .padding(.bottom,20)
                .padding(.trailing,10)
                
                // Question with a blank to fill in
                Text(modifiedExample)
                    .fontWeight(.semibold)
                      .font(.system(size: 18))
                      .frame(maxWidth: 360, alignment: .leading)
                      .padding(.leading, 10)
                      .padding(.vertical, 25)
                      .background(.white)
                      .cornerRadius(10)
                      .multilineTextAlignment(.leading)
                      .lineLimit(nil)
                      .fixedSize(horizontal: false, vertical: true)
                
                // Japanese Translation as a hint
                Text(viewModel.decks[selectedDeck].words[viewModel.randomInt].translation)
                    .fontWeight(.semibold)
                    .padding(.top,10)
                    .padding(.horizontal)
                    .frame(maxWidth: 360, alignment: .leading)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer().frame(height: 30)
                
                Text("Complete the sentence!")
                    .font( .system(size: 23))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 5)
                    .padding(.leading, 10)
                
                TextField("Write your answer here!", text: $viewModel.writtenAnswer)
                    .padding()
                    .background(Color.white)
                    .frame(width:300)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .padding(.horizontal)
                    .padding(.top,10)
                    .padding(.bottom,40)
                    .focused(self.$focus)
                    .keyboardType(.alphabet)
                            
                if showPopup {
                    VStack {
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .font(.title)
                            
                            Text("Good Job!")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.vertical, 20)
                        
                        Button {
                            // Check of all all words in the deck has been used
                            if viewModel.checkIfAllWordsUsed() {
                                print("Finished all the words in the deck")
                                // Jump to the result view
                                isResuktViewActive = true
                            }
                            else {
                                
                                // Remove the text in the text field
                                print("Empying the text field...")
                                viewModel.resetTextField()
                                // Generate a new integer for the next question
                                print("Generating a new word...")
                                viewModel.randomInt = viewModel.generateRandomQuestion()
                                
                                // Assign the new integer to the array
                                viewModel.usedWordsIndex.append(viewModel.randomInt)
                                progress = viewModel.calculateProgress(selectedDeck)
                                withAnimation {
                                    showPopup = false // Animated disappearance
                                }
                                
                                isAnswerCorrect = false
                            }
                        } label: {
                            Text("Continue")
                                .fontWeight(.semibold)
                                .frame(maxWidth: 200, maxHeight: 60)
                                .background(.white)
                                .cornerRadius(20)
                        }
                        .padding(.bottom, 20)
                        .navigationDestination(isPresented: $isResuktViewActive) {
                            ResultView(viewModel: PlayStudyViewModel(), selectedDeck: $selectedDeck, wrongWordIndex: $viewModel.wrongWordsIndex)
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
             
                if !isAnswerCorrect {
                    Button {
                        // Check if the inputted answer is correct
                        isAnswerCorrect = viewModel.checkIfAnswerIsCorrect()
                        
                        // Dismiss the keyboard
                        self.focus = false
                        
                        if isAnswerCorrect {
                            totalPoints += 1
                            withAnimation {
                                showPopup = true
                            }
                        }
                        else {
                            // Assign the word into the array
                            viewModel.wrongWordsIndex.append(viewModel.randomInt)
                            print("The wrong words are:")
                            for index in viewModel.wrongWordsIndex {
                                print("\(viewModel.decks[selectedDeck].words[index].word)")
                            }
                        }
                    } label: {
                        Text("Check")
                            .fontWeight(.semibold)
                            .frame(width: 300, height:30)
                        
                    }
                    .disabled(viewModel.writtenAnswer.isEmpty)
                    .padding()
                    .foregroundStyle(.black)
                    .background(.white)
                    .cornerRadius(20)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
    }

}
#Preview {
    // Create a sample instance of PlayStudyViewModel with a sample deck index
    let sampleViewModel = PlayStudyViewModel()
    // Pass the sample ViewModel and selectedDeck binding to the preview
    PlayStudyView(viewModel: sampleViewModel, selectedDeck: .constant(0))
}
