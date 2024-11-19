import SwiftUI

struct CreateDeckView: View {
    
    @ObservedObject var viewModel: DeckWordViewModel
    @State private var deckName: String = ""
    @State private var activeAlert: Bool = false
    @State private var isDeckListActive: Bool = false
    @State var selectedDeck: Int
    @Binding var selectedColor: Color
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Create a new deck!")
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .padding(.vertical,30)
                    
                HStack {
                    TextField("Deck name here", text: $deckName)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .frame(width: 280, height: 30)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .padding(.leading)
                      
                    Button(action: {
                        deckName = ""
                    }) {
                        Image(systemName: "delete.left")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                    .padding(.top, 4)
                    .opacity(deckName.isEmpty ? 0 : 1)
                }
                
                Spacer().frame(height: 20)
                
                Button {
                    if deckName.isEmpty {
                        activeAlert = true
                    }
                    else if viewModel.checkIfNameExists(deckName) {
                        print("It has already existed")
                        // Clear the text field
                        deckName = ""
                    }
                    else {
                        // Create a new deck
                        let newDeck = Deck(id: 0, name: deckName, deckOrder: viewModel.decks.count, userId: 1)
                        
                        // Add the new deck to the deck array
                        viewModel.decks.append(newDeck)
                        
                        print("Deck added: \(newDeck.name)")
                        print("Updated decks list: \(viewModel.decks.map { $0.name })")
                        
                        // Save the newly entered deck to the db (仮)
                        Task {
                            do {
                                let newDeck = try await DeckService.shared.addDeck(name: deckName, deckOrder: viewModel.decks.count, userId: 1)
                                
                                print("Deck added: \(newDeck.name)")
                                
                            } catch {
                                print("Error in saving the new deck: \(error.localizedDescription)")
                            }
                        }
                                            
                        // Clear the text field
                        deckName = ""
                        // Jump back to the word list
                        isDeckListActive = true
                    }
                
                } label: {
                    Text("Save")
                }
                .disabled(deckName.isEmpty)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .frame(width:140, height:15)
                .padding()
                .background(deckName.isEmpty ? .gray : .blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.top,20)
                .alert(isPresented: $activeAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Please fill in the blank")
                    )
                }
                .navigationDestination(isPresented: $isDeckListActive) {
                    DeckListView(viewModel: DeckWordViewModel(), selectedDeck: selectedDeck, selectedColor: $selectedColor)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(selectedColor)
        }
    }
}

#Preview {
    let sampleViewModel = DeckWordViewModel()
    CreateDeckView(viewModel: sampleViewModel, selectedDeck: 1, selectedColor: .constant(.teal))
}
