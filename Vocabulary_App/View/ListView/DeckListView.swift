import SwiftUI

// TO DO LIST
// 1. Users turn to the next page to see more decks (pagination)
// 2. Users see the alert and then can delete a deck
// 3. Users can sort the list of decks by date added or in alphabetical order, in either ascending or descending order.
// 4. Users can drag and drop the deck to change the order of the decks.

struct DeckListView: View {
    @Binding var decks: [Deck]
    @State private var isCreateDeckActive = false
    @State private var deckToEdit: UUID?
    @State private var newDeckName: String = ""
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($decks) { $deck in
                    NavigationLink(destination: WordListView(deck: deck)) {
                        HStack {
                            Text(deck.name)
                                .fontWeight(.bold)
                                .padding(.vertical, 4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .gesture(
                                    LongPressGesture(minimumDuration: 1.0)
                                        .onEnded { _ in
                                            deckToEdit = deck.id
                                            newDeckName = deck.name
                                            showSheet = true
                                        }
                                )
                        }
                    }
                }
            }
            .background(.blue.gradient)
            .scrollContentBackground(.hidden)
            .navigationTitle("All Decks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isCreateDeckActive = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .foregroundStyle(.white)
                    .padding(.trailing, 10)
                    .navigationDestination(isPresented: $isCreateDeckActive) { CreateDeckView() }
                    .navigationBarBackButtonHidden()
                }
            }
            .sheet(isPresented: $showSheet) {
                VStack {
                    Spacer()
                    Text("Edit the Deck Name")
                        .fontWeight(.semibold)
                        .font(. system(size: 23))
                        .padding(.top,25)
                    
                    TextField("", text: $newDeckName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .padding(.horizontal)
                   
                    Button("Save") {
                        // Find the deck index using deckToEdit
                        if let deckToEdit = deckToEdit,
                           let index = decks.firstIndex(where: { $0.id == deckToEdit }) {
                            // Update the deck name with newDeckName
                            decks[index].name = newDeckName
                        }
                        
                        // Call a http request to update the deck name here
                        
                        // Dismiss the sheet
                        showSheet = false
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .padding(.bottom,30)
                .background(.blue.opacity(0.5))
            }
        }
    }
}

struct CreateDeckView_Previews: PreviewProvider {
    @State static var decks: [Deck] = [
        Deck(name: "Sample Deck1", words: [
            Word(word: "Procrastinate", definition: "後回しにする", example: "I procrastinated my assignments, but I finished them in time.", translation: "私は課題を後回しにした。"),
            Word(word: "Ubiquitous", definition: "どこにでもある", example: "Smartphones are ubiquitous nowadays.", translation: "スマホは至る所にある")
        ])
    ]
    
    static var previews: some View {
        DeckListView(decks: $decks)
    }
}
