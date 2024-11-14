import SwiftUI

struct WordDetailView: View {
    
    // TO DO LIST
    // Display the example without {{}} 
    
    let word: Word
    @State private var showSheet: Bool = false
    @State private var newWord: String = ""
    @State private var newDefinition: String = ""
    @State private var newExample: String = ""
    @State private var newTranslation: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Word Details")
                    .font(.system(size: 35, weight: .semibold, design: .rounded))
                    .padding(.top,20)
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
                        Text(word.example)
                            .padding(.vertical, 4)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                    }
                    
                    Section(header: Text("Translation").font(.headline)) {
                        Text(word.translation)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding(.vertical, 4)
                    }
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
                                TextField(word.example, text: $newExample)
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
                        .frame(height:450)
                
                        Button {
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
                
                Button {
                    showAlert = true
                } label: {
                    Text("Delete")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
                .padding()
                .fontWeight(.semibold)
                .background(Color.white)
                .foregroundColor(.red)
                .cornerRadius(8)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Are you sure you want to delete?"),
                        message: Text("This will permanently delete the word info."),
                        primaryButton: .destructive(Text("Delete")) {
                            print("Word info deleted")
                            // Logics to delete the word info here!
                            // Refresh the word list and jump to the word view
                        },
                        secondaryButton: .cancel()
                    )
                }
                Spacer().frame(height: 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
        }
    }
}

#Preview {
    WordDetailView(word: Word(word: "Hello", definition: "こんにちは", example: "{{Hello}}, how are you? - I am doing good! How are you doing?", translation: "こんにちは、元気?", wordOrder: 1, deckId: 1))
}
