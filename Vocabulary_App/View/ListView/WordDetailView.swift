import SwiftUI

struct WordDetailView: View {

    let word: Word
    @ObservedObject var viewModel : DeckWordViewModel
    @State private var showSheet: Bool = false
    @State private var newWord: String = ""
    @State private var newDefinition: String = ""
    @State private var newExample: String = ""
    @State private var newTranslation: String = ""
    @State private var showAlert: Bool = false
    @State private var modifiedExample : String = ""
    @State private var isWordListViewActive : Bool = false
    @Binding var selectedColor: Color
    
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
                .sheet(isPresented: $showSheet) {
                    VStack {
                        
                        Spacer().frame(height:30)
                        
                        Text("Edit the Word")
                            .font(.system(size: 23, weight: .semibold, design: .rounded))
                            .padding(.top,25)
                        
                        List {
                            Section(header: Text("Word").font(.headline)) {
                                TextField(word.word, text: $newWord)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.vertical, 4)
                            }
                            
                            Section(header: Text("Definition").font(.headline)) {
                                TextField(word.definition, text: $newDefinition)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.vertical, 4)
                            }
                            
                            Section(header: Text("Example").font(.headline)) {
                                TextField(modifiedExample, text: $newExample)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.vertical, 4)
                            }
                            
                            Section(header: Text("Translation").font(.headline)) {
                                TextField(word.translation, text: $newTranslation)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.vertical, 4)
                            }
                        }
                        // Remove the gap at the bottom of the list
                        .frame(height:430)
                
                        Button {
                            // Logics here to edit the word info from the db
                            
                            // Dismiss the sheet once the editing request succeeds
                            showSheet = false
                        } label: {
                            Text("Save")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                        }
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
                    showSheet.toggle()
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
//                            Task {
//                                do {
//                                    let removedWord = WordService.shared.deleteWord(word: word)
//                                } catch {
//                                    print("Error in deleting the word info: \(error.localizedDescription)")
//                                }
//                            }
                            // Logics to refresh the word list
//                            Task {
//                                do {
//                                    let newList = WordService.shared.getWordList()
//                                } catch {
//                                    
//                                }
//                            }
                            
                            // Logics here to jump to the word view if deletion succeeds
                            isWordListViewActive = true
                        },
                        secondaryButton: .cancel()
                    )
                }
                Spacer().frame(height: 20)
              
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(selectedColor)
        }
    }
}

#Preview {
    WordDetailView(word: Word(id: 0, word: "Hello", definition: "こんにちは", example: "{{Hello}}, how are you? - I am doing good! How are you doing?", translation: "こんにちは、元気?", correctTimes: 0, word_order: 1, deckId: sampleDecks[0].id), viewModel: DeckWordViewModel(), selectedColor: .constant(.teal))
}
