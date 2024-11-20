import SwiftUI

struct CreateDeckView: View {
    
    @ObservedObject var viewModel: DeckWordViewModel
    @State private var deckName: String = ""
    @State private var activeAlert: Bool = false
    @State private var isDeckListActive: Bool = false
    @State var selectedDeck: Int
    @Binding var selectedColor: Color
    @Binding var userId : Int
    @Binding var decksCount : Int
    @Binding var fetchedDecks : [Deck]
    
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
                        .onChange(of:deckName) {
                            print("The entered deck name:\(deckName)")
                        }
                      
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
                    else if viewModel.checkIfNameExists(deckName, fetchedDecks: fetchedDecks) {
                        print("\(deckName) has already existed.")
                        // Clear the text field
                        deckName = ""
                    }
                    else {
                        Task {
                            do {
                                print("Deck Counts:\(decksCount)")
                                // Call a func to add a new deck
                                _ = try await DeckService.shared.addDeck(name: deckName, deckOrder: decksCount + 1, userId: userId)
                                
                                // Call a func to fetch decks to update the list view
                                _ = try await DeckService.shared.getDecks(userId: userId)
                                
                                // Clear the text field
                                deckName = ""
                                // Jump back to the word list
                                isDeckListActive = true
                                
                            } catch {
                                print("Error in saving the new deck: \(error.localizedDescription)")
                            }
                        }
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
                    DeckListView(viewModel: DeckWordViewModel(), selectedDeck: selectedDeck, selectedColor: $selectedColor, userId: $userId)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(selectedColor)
            .onAppear {
                print("The user we are using is: \(userId)")
            }
        }
    }
}

#Preview {
    
    let mockDecks = [
            Deck(id: 1, name: "Deck 1", deckOrder: 1, userId: 1),
            Deck(id: 2, name: "Deck 2", deckOrder: 2, userId: 1)
        ]
    
    let sampleViewModel = DeckWordViewModel()
    CreateDeckView(viewModel: sampleViewModel, selectedDeck: 1, selectedColor: .constant(.teal), userId: .constant(1), decksCount: .constant(1), fetchedDecks: .constant(mockDecks))
}
