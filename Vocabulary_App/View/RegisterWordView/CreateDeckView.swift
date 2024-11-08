import SwiftUI

// TO DO LIST
// 1. Users cannnot make the two decks with the same name

struct CreateDeckView: View {
    
    @State private var deckName: String = ""
    @State private var activeAlert: Bool = false
    @State private var isDeckListActive: Bool = false
    @State private var decks: [Deck] = sampleDecks
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Create a new deck!")
                    .padding(.vertical,30)
                    .fontWeight(.bold)
                    .font(. system(size: 25))
                
                HStack {
                    TextField("Deck name here", text: $deckName)
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
                    else {
                        let newDeck = Deck(name: deckName)
                        // Temporary method to create a new deck
                        decks.append(newDeck)
                        //    Save the new deck to the database
                        //    saveDeckToDatabase(newDeck) { success in
                        //    if success {
                        //     refresh the local deck list from the server or update the UI
                        //    fetchDecksFromDatabase()
                        //    print("Deck saved successfully.")
                        //     } else {
                        //     print("Failed to save deck.")
                        //     }
                        //  }
                        
                        deckName = ""
                        isDeckListActive = true
                    }
                    
                } label: {
                    Text("Create")
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .frame(maxWidth: 200, minHeight: 40)
                }
                .background(.white)
                .cornerRadius(10)
                .alert(isPresented: $activeAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Please fill in the blank")
                    )
                }
                .navigationDestination(isPresented: $isDeckListActive) { DeckListView(decks: $decks) }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
        }
    }
}

#Preview {
    CreateDeckView()
}
