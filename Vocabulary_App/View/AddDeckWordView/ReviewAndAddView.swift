import SwiftUI

struct ReviewAndAddView: View {
    
    @ObservedObject var viewModel : DeckWordViewModel
    @Binding var word: String
    @Binding var definition: String
    @Binding var example: String
    @Binding var translation: String
    @Binding var currentStep: Int
    @Binding var selectedColor: Color
    @Binding var selectedDeck : Int
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height:20)
                Text("Review")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                
                // Progress Bar
                HStack {
                    ForEach(1...3, id: \.self) { step in
                        HStack {
                            Circle()
                                .strokeBorder(step == currentStep ? Color.blue : Color.gray, lineWidth: 2)
                                .background(Circle().foregroundColor(step == currentStep ? Color.blue : Color.white))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text("\(step)")
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(step == currentStep ? Color.white : Color.gray)
                                        .font(.headline)
                                )
                            
                            // Connecting line except after the last step
                            if step < 3 {
                                Rectangle()
                                    .fill(step < currentStep ? Color.blue : Color.gray)
                                    .frame(height: 2)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity).padding(.horizontal)
                
                Form {
                    Section(header: Text("Word Details")) {
                        Text(word)
                            .foregroundColor(.blue)
                            .font(.system(size: 25, weight: .semibold, design: .rounded))
                        
                        Text(definition)
                            .foregroundColor(.black)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                    }
                    
                    Section(header: Text("Example Sentence")) {
                        Text(example)
                            .foregroundColor(.blue)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                        
                        Text(translation)
                            .foregroundColor(.black)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(height: 400)
                                
                Spacer().frame(height: 40)
                HStack {
                    Button {
                        currentStep = 2
                    } label: {
                        Text("Previous")
                         
                    }
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .frame(width:100)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Spacer().frame(width: 30)
                    
                    Button {
                        print("Add the word and example into.....")
                        print("Adding the word into Deck ID \(selectedDeck)")
                     
                        // Save the newly entered word to the db
                        Task {
                            do {
                                // Call a func to add a new word (selectedDeck(=index)じゃなくて、decks[selectedDeck].id使う??
                                _ = try await WordService.shared.addWords(word: word, definition: definition, example: definition, translation: translation, wordOrder: 0, deckId: selectedDeck)
                                
                                // Call a func to fetch words to update the word list 
                                // _ = try await WordService.shared.getWords(deckId: <#Int#>)
                                
                                // Navigate to WordListView
                                currentStep = 0
                            } catch {
                                print("Error in saving the new word: \(error.localizedDescription)")
                            }
                        }
                        
                    } label: {
                        Text("Save")
                    }
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .frame(width:100)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(selectedColor)
            .navigationBarBackButtonHidden()
            .onAppear {
                print("Selected Deck: \(selectedDeck)")
            }
        }
    }
}

#Preview {
    ReviewAndAddView(
        viewModel: DeckWordViewModel(), word: .constant("Procrastinate"),
        definition: .constant("後回しにする"),
        example: .constant("I tend to procrastinate and start to work on assessments in the last minutes before they are due."),
        translation: .constant("私は後回しにすることが多く、締め切り直前に課題に取り掛かります。"),
        currentStep: .constant(3),
        selectedColor: .constant(.teal),
        selectedDeck: .constant(1)
    )
}


