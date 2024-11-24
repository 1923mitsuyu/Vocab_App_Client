import SwiftUI

// TO DO LIST
// 1. Keyboardが背景がTapされたら消えるようにする
// 2. TextFieldの大きさが文字列の長さによって変わるようにする
// 3. TextFieldの右端に消去マークを追加する

struct WordDetailView: View {

    let word: Word
    @ObservedObject var viewModel : DeckWordViewModel
    @State private var showEditSheet: Bool = false
    @State private var newWord: String = ""
    @State private var newDefinition: String = ""
    @State private var newExample: String = ""
    @State private var newTranslation: String = ""
    @State private var showAlert: Bool = false
    @State private var modifiedExample : String = ""
    @State private var isWordListViewActive : Bool = false
    @Binding var selectedColor: Color
    @Binding var fetchedWords : [Word]
    @Binding var selectedDeckId : Int
    @Binding var currentStep: Int
    @Binding var selectedDeck : Int
    @Binding var fetchedDecks : [Deck]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Word Details")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .padding(.bottom, -3)
                
                List {
                    Section(header: Text("Word").font(.headline)) {
                        Text(word.word)
                            .font(.system(size: 25, weight: .bold, design: .rounded))
                            .padding(.vertical, 4)
                    }
                    
                    Section(header: Text("Definition").font(.headline)) {
                        Text(word.definition)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding(.vertical, 4)
                    }
                    
                    Section(header: Text("Example").font(.headline)) {
                        Text(modifiedExample)
                            .padding(.vertical, 4)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                    }
                    
                    Section(header: Text("Translation").font(.headline)) {
                        Text(word.translation)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding(.vertical, 4)
                    }
                }
                .frame(height: 600)
                .onAppear {
                    modifiedExample = viewModel.removeBrackets(word.example)
                }
                .scrollContentBackground(.hidden)
                .sheet(isPresented: $showEditSheet) {
                    VStack {
                        
                        Spacer().frame(height:10)
                        
                        Text("Edit the Word")
                            .font(.system(size: 23, weight: .semibold, design: .rounded))
                            .padding(.top)
                        
                        List {
                            Section(header: Text("Word").font(.headline)) {
                                TextField("", text: $newWord)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.vertical, 4)
                            }
                            
                            Section(header: Text("Definition").font(.headline)) {
                                TextField("", text: $newDefinition)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.vertical, 4)
                            }
                            
                            Section(header: Text("Example").font(.headline)) {
                                TextEditor(text: $newExample)
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                        .frame(width: 330, height: 60)
                                     
                            }
                            
                            Section(header: Text("Translation").font(.headline)) {
                                TextEditor(text: $newTranslation)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .frame(width: 330, height: 60)
                            }
                        }
                        // Remove the gap at the bottom of the list
                        .frame(height:550)
                     
                        Button {
                            // Logics here to edit the word info from the db
                            Task {
                                do {
                                    print("The word id and name to be edited is \(word.id) and \(word.word)")
                                    // Call a func to edit the word list
                                    _ = try await WordService.shared.editWord(wordId: word.id, word: newWord, definition: newDefinition, example: newExample, translation: newTranslation)
                                    
                                    // Reset the word
                                    fetchedWords = []
                                    
                                    // Fetch all the words in the selected deck from the db
                                    fetchedWords = try await WordService.shared.getWords(deckId: selectedDeckId)
                                    
                                    // Dismiss the sheet
                                    showEditSheet = false
                                    
                                    modifiedExample = viewModel.removeBrackets(newExample)
                                    
                                } catch {
                                    print("Error in editing a word: \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            Text("Save")
                        }
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .frame(width:150, height:15)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        Spacer()
                        
                    }
                    .scrollContentBackground(.hidden)
                    .background(.blue.opacity(0.5))
                }
                .onTapGesture {
                    showEditSheet.toggle()
                    
                    // Pass the current values to show them on each of the text fields on the editing sheet
                    newWord = word.word
                    newDefinition = word.definition
                    newExample = word.example
                    newTranslation = word.translation
                }
                
                Spacer().frame(height: 30)
                Button {
                    showAlert = true
                } label: {
                    Text("Delete")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
                .padding(.horizontal,50)
                .padding(.vertical,10)
                .fontWeight(.semibold)
                .background(.white)
                .foregroundColor(.red)
                .cornerRadius(8)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Are you sure you want to delete?"),
                        message: Text("This will permanently delete the word info."),
                        primaryButton: .destructive(Text("Delete")) {
                            print("Word info deleted")
                            // Logics here to delete the word
                            Task {
                                do {
                                    print("The selected deck id is: \(selectedDeckId)")
                                    _ = try await WordService.shared.deleteWord(wordId: word.id, deckId: selectedDeckId)
                                    
                                    // Reset the word
                                    fetchedWords = []
                                    
                                    // Fetch all the words in the selected deck from the db
                                    fetchedWords = try await WordService.shared.getWords(deckId: selectedDeckId)
                                    
                                    // Logics here to jump to the word view if deletion succeeds
                                    // isWordListViewActive = true
                                    
                                } catch {
                                    print("Error in deleting the word: \(error.localizedDescription)")
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
//                .navigationDestination(isPresented: $isWordListViewActive) {
//                    WordListView(viewModel: DeckWordViewModel(), fetchedWords: $fetchedWords, selectedDeckId: $selectedDeckId, currentStep: $currentStep, selectedDeck: $selectedDeck, selectedColor: $selectedColor, fetchedDecks: $fetchedDecks)
//                }
                Spacer().frame(height: 20)
              
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
        }
    }
}

#Preview {
    
    let mockDecks = [
            Deck(id: 1, name: "Deck 1", deckOrder: 1, userId: 1),
            Deck(id: 2, name: "Deck 2", deckOrder: 2, userId: 1)
        ]
    
    let mockWords = [Word(id: 0, word: "Apple", definition: "りんご", example: "I eat an {{apple}} every morning but I did not eat it this morning. I just wanted to eat something different.", translation: "私は毎朝リンゴを食べますが、今朝は食べませんでした。違うものを食べたかったんです。", correctTimes: 0, word_order: 1, deckId: sampleDecks[0].id)]
    
    WordDetailView(word: Word(id: 0, word: "Hello", definition: "こんにちは", example: "Hello, how are you? - I am doing good! How are you doing?", translation: "こんにちは、元気?", correctTimes: 0, word_order: 1, deckId: sampleDecks[0].id), viewModel: DeckWordViewModel(), selectedColor: .constant(.teal), fetchedWords: .constant(mockWords), selectedDeckId: .constant(1), currentStep: .constant(1), selectedDeck: .constant(1), fetchedDecks: .constant(mockDecks))
}
