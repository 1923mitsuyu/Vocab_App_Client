import SwiftUI

// TO DO LIST
// Implement a pagination for increased number of decks

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
                    Spacer().frame(height:20)
                    Text("Edit the Deck Name")
                        .fontWeight(.semibold)
                        .font(. system(size: 23))
                        .padding(.top,25)
                    
                    List {
                        Section(header: Text("Deck Name").font(.headline)) {
                            TextField("", text: $newDeckName)
                                .font(.body)
                                .padding(.vertical, 4)
                        }
                    }
                    
                    Button("Save") {
                        // Find the deck index using deckToEdit
                        if let deckToEdit = deckToEdit,
                           let index = decks.firstIndex(where: { $0.id == deckToEdit }) {
                            // Update the deck name with newDeckName
                            decks[index].name = newDeckName
                        }
                        showSheet = false
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    Spacer().frame(height:500)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
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
