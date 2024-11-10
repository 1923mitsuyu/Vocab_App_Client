import SwiftUI

// TO DO LIST
// 1. Disable the button when the textfield is empty
// 2. Show the pop up if the answer is correct
// 3. Put all incorrect words into the array and pass it to the next view
// 4. Put a Japanese translation of the example sentence as a hint to the user

struct PlayStudyView: View {
    
    @StateObject var viewModel: PlayStudyViewModel
    @State private var decks: [Deck] = sampleDecks
    @Binding var selectedDeck: Int
    @State private var progress = 0.1
    @State private var isStudyHomeViewActive: Bool = false
    @State private var isResuktViewActive: Bool = false
    @State private var isAnswerCorrect: Bool = false
    @State private var totalPoints: Int = 0
    @State private var showAlert : Bool = false
        
    var body: some View {
        let example = decks[selectedDeck].words[viewModel.randomInt].example
        let modifiedExample = viewModel.hideTargetWordInExample(example)
        
        NavigationStack {
            VStack {
                
                Spacer().frame(height: 30)
                
                ProgressView(value: progress)
                    .frame(width: 320)
                    .accentColor(.white)
                    .padding(.bottom,20)
                
                Text("Read and answer the question")
                    .font( .system(size: 23))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom,30)
                    .padding(.leading, 10)
                
                Text(modifiedExample)
                    .fontWeight(.semibold)
                    .font( .system(size: 18))
                    .frame(maxWidth: 360, alignment: .leading)
                    .padding(.leading, 10)
                    .padding(.vertical,25)
                    .background(.white)
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
                
                
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
                    .padding(.vertical,10)
                
                Spacer()
                
                HStack{
                    Button {
                        isStudyHomeViewActive = true
                    } label: {
                        Text("Quit")
                            .fontWeight(.semibold)
                            .frame(width: 80, height:30)
                    }
                    .padding()
                    .foregroundStyle(.black)
                    .background(.white)
                    .cornerRadius(20)
                    .navigationDestination(isPresented: $isStudyHomeViewActive) {
                        StudyHomeView(viewModel: PlayStudyViewModel())
                    }
                    
                    Spacer().frame(width: 25)
                    
                    Button {
                        // Check if the inputted answer is correct
                        isAnswerCorrect = viewModel.checkIfAnswerIsCorrect()
                        print("Correct Answer?: \(isAnswerCorrect)")
                        if isAnswerCorrect {
                            totalPoints += 1
                            showAlert = true
                        }
                        
                        // Check of all all words in the deck has been used
                        if viewModel.checkIfAllWordsUsed() == true {
                            print("Finished all the words in the deck")
                            // Jump to the result view
                            isResuktViewActive = true
                        }
                        else {
                            // Remove the text in the text field
                            viewModel.resetTextField()
                            // Generate a new integer for the next question
                            viewModel.randomInt = viewModel.generateRandomQuestion()
                            // Assign the new integer to the array
                            viewModel.usedWordsIndex.append(viewModel.randomInt)
                            // print("Newly Generated Number: \(randomWordNumber)")
                            // print("Used Number: \(viewModel.usedWordsIndex)")
                        }
                    } label: {
                        Text("Check")
                            .fontWeight(.semibold)
                            .frame(width: 80, height:30)
                    }
                    .padding()
                    .foregroundStyle(.black)
                    .background(.white)
                    .cornerRadius(20)
                    .navigationDestination(isPresented: $isResuktViewActive) {
                        ResultView(selectedDeck: $selectedDeck)
                    }
                }
                Spacer().frame(height: 30)
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

