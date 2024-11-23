import SwiftUI

// TO DO LIST
// 1. Users turn to the next page to see more decks (pagination) : Priority 2

struct DeckListView: View {
    
    @StateObject var viewModel = DeckWordViewModel()
    @State var fetchedDecks : [Deck] = []
    @State var selectedDeck = 0
    @State private var isCreateDeckActive = false
    @State private var deckToEdit: Int?
    @State private var deckToDelete: Int?
    @State private var newDeckName: String = ""
    @State private var showEditSheet: Bool = false
    @State private var isPickerPresented = false
    @State private var selectedSortOption = "Name"
    @State private var showDeleteAlert : Bool = false
    @State private var decksCount : Int = 0
    @State private var errorMessage : String = ""
    @Binding var selectedColor: Color
    @Binding var userId : Int
    @State private var initialSelectedDeck : Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("All Decks")
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .padding(.leading)
                                          
                    NavigationLink {
                        CreateDeckView(
                            viewModel: viewModel,
                            selectedDeck: selectedDeck,
                            selectedColor: $selectedColor,
                            userId: $userId,
                            decksCount: $decksCount,
                            fetchedDecks: $fetchedDecks
                        )
                       } label: {
                           Image(systemName: "plus")
                               .font(.system(size: 25))
                               .foregroundStyle(.white)
                               .padding(.trailing, 10)
                       }
                    
                    Button(action: {
                        isPickerPresented.toggle()
                    }) {
                        Image(systemName: "list.bullet")
                    }
                    .font(.system(size: 25)) 
                    .foregroundStyle(.white)
                    .padding(.trailing, 30)
                }
                .padding(.bottom, -15)
                .padding(.top, 20)
             
                List($fetchedDecks,editActions: .move) { $deck in
                    NavigationLink(
                        destination: NavigationParentView(deck: deck, selectedDeck: $selectedDeck, selectedColor: $selectedColor,fetchedDecks: $fetchedDecks, initialSelectedDeck: $initialSelectedDeck)
                            .onAppear {
                                if let index = fetchedDecks.firstIndex(where: { $0.id == deck.id }) {
                                    selectedDeck = index
                                    print("1.SelectedDeck is \(selectedDeck)")
                                }
                            }
                    ) {
                        Text(deck.name)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .swipeActions {
                        Button(role: .destructive, action: {
                            deckToDelete = deck.id
                            showDeleteAlert = true
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        Button(action: {
                            deckToEdit = deck.id
                            newDeckName = deck.name
                            showEditSheet = true
                            // The deck id and name to edit: Optional(15) and Deck1
                            print("The deck id and name to edit: \(String(describing: deckToEdit)) and \(newDeckName)")
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                }
                .cornerRadius(10)
                .onAppear {
                    // Fetch all decks from the db
                    Task {
                        do {
                            fetchedDecks = try await DeckService.shared.getDecks(userId: userId)
                            decksCount = fetchedDecks.count
                            print("The number of decks in the deck: \(decksCount)")
                                  
                        } catch {
                            print("Error in fetching all decks: \(error.localizedDescription)")
                        }
                    }
                }
                .onChange(of: fetchedDecks) { oldValue, newValue in
                    print("The deck list changed!")
                    var counter = 0
                    for index in fetchedDecks.indices {
                        fetchedDecks[index].deckOrder = counter
                        print("Deck Name: \(fetchedDecks[index].name), List Order: \(fetchedDecks[index].deckOrder)")
                        counter += 1
                    }
                    print("--------------------------------")
                    
                    // Call a editing func to update the deck order
//                    Task {
//                        do {
//                            _ = try await DeckService.shared.updateDeckOrder()
//
//                        } catch {
//                            print("Error in updating the deck order: \(error.localizedDescription)")
//                        }
//                    }
                }
                .scrollContentBackground(.hidden)
                .actionSheet(isPresented: $isPickerPresented) {
                    ActionSheet(
                        title: Text("Select Sorting Option"),
                        buttons: [
                            .default(Text("By Name(Ascending)")) {
                                selectedSortOption = "Name"
                                fetchedDecks.sort { $0.name < $1.name }
                            },
                            .default(Text("By Name (Descending)")) {
                                selectedSortOption = "Name"
                                fetchedDecks.sort { $0.name > $1.name }
                            },
                            .default(Text("By Date Added")) {
                                selectedSortOption = "Date Added"
                                fetchedDecks.sort { $0.deckOrder < $1.deckOrder }
                            },
                            .cancel()
                        ]
                    )
                }
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("Delete Deck"),
                        message: Text("Are you sure you want to delete this deck?"),
                        primaryButton: .destructive(Text("Delete")) {
                            
                            guard let deckToDelete = deckToDelete else {
                                print("Error: deckToEdit is nil")
                                return
                            }
                            
                            Task {
                                do {
                                    print("The deck id to be deleted is: \(deckToDelete)")
                                    _ = try await DeckService.shared.deleteDeck(deckId: deckToDelete, userId: userId)
                                    
                                    // Reset the word
                                    fetchedDecks = []
                                    
                                    // Fetch all the words in the selected deck from the db
                                    fetchedDecks = try await DeckService.shared.getDecks(userId: userId)
                                    
                                } catch {
                                    print("Error in deleting the deck: \(error.localizedDescription)")
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .sheet(isPresented: $showEditSheet) {
                    VStack {
                        Spacer().frame(height:20)
                        Text("Edit the Deck Name")
                            .font(.system(size: 25, weight: .semibold, design: .rounded))
                            .padding(.top, 25)
                            .padding(.bottom,20)
                        
                        TextField("", text: $newDeckName)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray, lineWidth: 2)
                                    
                                    HStack {
                                        Spacer()
                                        if !newDeckName.isEmpty {
                                            Button(action: {
                                                newDeckName = ""
                                            }) {
                                                Image(systemName: "delete.left")
                                                    .foregroundColor(Color(UIColor.opaqueSeparator))
                                            }
                                            .padding(.trailing, 15)
                                        }
                                    }
                                }
                            )
                            .padding(.horizontal)
                            .padding(.horizontal)
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundStyle(.red)
                                .padding(10)
                        } else {
                            Spacer().frame(height:60)
                        }
                        
                        Button {
                            guard let deckToEdit = deckToEdit else {
                                print("Error: deckToEdit is nil")
                                return
                            }
                            
                            if viewModel.checkIfNameExists(newDeckName, fetchedDecks: fetchedDecks) {
                                // Assign an error message
                                errorMessage = "\(newDeckName) has already existed."
                                
                                // Clear the text field
                                newDeckName = ""
                                
                                // Remove the error message in 3 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    errorMessage = ""
                                }
                            } else {
                                Task {
                                    do {
                                        _ = try await DeckService.shared.editDeck(deckId: deckToEdit, name: newDeckName)
                                        
                                        // Empty the deck list first
                                        fetchedDecks = []
                                        // Fetch the decks to update the list
                                        fetchedDecks = try await DeckService.shared.getDecks(userId: userId)
                          
                                        // Dismiss the sheet
                                        showEditSheet = false
                                    } catch {
                                        errorMessage = "Error in editing the deck. Try again later."
                                        print("Error in editing the deck: \(error.localizedDescription)")
                                        
                                        // Remove the error message in 3 seconds
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            errorMessage = ""
                                        }
                                    }
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scrollContentBackground(.hidden)
                    .padding(.bottom, 30)
                    .background(.blue.opacity(0.5))
                }
            }
            .background(.blue.gradient)
            .navigationBarBackButtonHidden()
        }
    }
}

struct CreateDeckView_Previews: PreviewProvider {
    @State static var decks: [Deck] = [
        Deck(id: 0, name: "Sample Deck1", deckOrder: 6, userId: 1),
        Deck(id: 1, name: "Sample Deck1", deckOrder: 6, userId: 1),
        Deck(id: 2, name: "Sample Deck1", deckOrder: 6, userId: 1),
        Deck(id: 3, name: "Sample Deck1", deckOrder: 6, userId: 1),
       ]
    
    static var previews: some View {
        DeckListView(viewModel: DeckWordViewModel(), selectedColor: .constant(.teal), userId: .constant(1))
    }
}
