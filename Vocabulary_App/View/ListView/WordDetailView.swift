import SwiftUI

// TO DO List (8/11)
// Make a button that includes a function to delete all info about the word

struct WordDetailView: View {
    
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
                List {
                    Section(header: Text("Word").font(.headline)) {
                        Text(word.word)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    
                    Section(header: Text("Definition").font(.headline)) {
                        Text(word.definition)
                            .font(.body)
                            .padding(.vertical, 4)
                    }
                    
                    Section(header: Text("Example").font(.headline)) {
                        Text(word.example)
                            .padding(.vertical, 4)
                            .fontWeight(.bold)
                    }
                    
                    Section(header: Text("Translation").font(.headline)) {
                        Text(word.translation)
                            .padding(.vertical, 4)
                    }
                }
                .navigationTitle("Word Details")
                .scrollContentBackground(.hidden)
                .sheet(isPresented: $showSheet) {
                    VStack {
                        Text("Edit the Word")
                            .fontWeight(.semibold)
                            .font(. system(size: 23))
                            .padding(.top,25)
                        
                        List {
                            Section(header: Text("Word").font(.headline)) {
                                TextField(word.word, text: $newWord)
                                    .font(.body)
                                    .padding(.vertical, 4)
                            }
                            
                            Section(header: Text("Definition").font(.headline)) {
                                TextField(word.definition, text: $newDefinition)
                                    .font(.body)
                                    .padding(.vertical, 4)
                            }
                            
                            Section(header: Text("Example").font(.headline)) {
                                TextField(word.example, text: $newExample)
                                    .padding(.vertical, 4)
                                    .fontWeight(.bold)
                            }
                            
                            Section(header: Text("Translation").font(.headline)) {
                                TextField(word.translation, text: $newTranslation)
                                    .padding(.vertical, 4)
                            }
                        }
                        
                        Button("Save") {
                            // Add a function to update the word data in the db
                            showSheet = false
                        }
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .cornerRadius(8)

                        Spacer().frame(height:200)
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
                }
                .padding()
                .fontWeight(.semibold)
                .background(Color.white)
                .foregroundColor(.red)
                .cornerRadius(8)
                .toolbar(.hidden, for: .tabBar)
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
    WordDetailView(word: Word(word: "Hello", definition: "こんにちは", example: "Hello, how are you? - I am doing good! How are you doing?", translation: "こんにちは、元気?"))
}
