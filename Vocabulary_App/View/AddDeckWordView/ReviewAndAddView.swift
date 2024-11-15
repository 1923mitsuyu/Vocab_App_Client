import SwiftUI

struct ReviewAndAddView: View {
    
    @ObservedObject var viewModel : DeckViewModel
    @Binding var word: String
    @Binding var definition: String
    @Binding var example: String
    @Binding var translation: String
    @Binding var note: String
    @Binding var currentStep: Int
    @Binding var deckId: UUID
    @Binding var deckName: String
    
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
                    
                    Section(header: Text("Note")) {
                        Text(note)
                            .foregroundColor(.black)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(height: 430)
                
                Spacer().frame(height:30)
                
                HStack {
                    Button {
                        currentStep = 2
                    } label: {
                        Text("Previous")
                         
                    }
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .frame(width:100)
                    .padding()
                    .background(.cyan)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Spacer().frame(width: 30)
                    
                    Button {
                        print("Add the word and example into.....")
                        print("Adding the word into Deck ID \(deckId)")
                        print("Adding the word into Deck Name \(deckName)")
                        
                        // Find the deck with the name and append the word info into the deck
//                        viewModel.addWordToDeck(word, definition, example, translation, deckName)
                        
                        // Logics here to save the newly entered word to the db
//                        Task {
//                            do {
//                                let newDeck = try await WordService.shared.saveWord()
//                            } catch {
//                                print("Error in saving the new word: \(error.localizedDescription)")
//                            }
//                        }
                        
                        // Logics to navigate to WordListView
                    
                    } label: {
                        Text("Save")
                    }
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .frame(width:100)
                    .padding()
                    .background(.cyan)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    ReviewAndAddView(
        viewModel: DeckViewModel(), word: .constant("Procrastinate"),
        definition: .constant("後回しにする"),
        example: .constant("I tend to procrastinate and start to work on assessments in the last minutes before they are due."),
        translation: .constant("私は後回しにすることが多く、締め切り直前に課題に取り掛かります。"),
        note:.constant("Procrastinator: 後回しにする人"),
        currentStep: .constant(3),
        deckId: .constant(UUID()),
        deckName: .constant("Deck1")
    )
}


