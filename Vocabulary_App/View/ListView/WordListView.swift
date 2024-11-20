import SwiftUI

// TO DO LIST 
// 1. Users turn to the next page to see more decks (pagination) : Priority 2
// 2. Users can tick off boxes that shows up when tapping one of the words in the list and then, they can delete the selected words : Priority 3

struct WordListView: View {
    
    @ObservedObject var viewModel : DeckWordViewModel
    @ObservedObject var deck: Deck
    @State var fetchedWords : [Word] = []
    @State private var isWordInputActive : Bool  = false
    @State private var isPickerPresented : Bool = false
    @State private var selectedSortOption : String = "Name"
    @State private var isChecked = false
    @State private var selectedDeckId : Int = 0
    @Binding var currentStep: Int
    @Binding var selectedDeck : Int
    @Binding var selectedColor: Color
    @Binding var fetchedDecks : [Deck]
        
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("All Words")
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .padding(.leading)
                      
                    Button(action: {
                        currentStep =  1
                    }) {
                        Image(systemName: "plus")
                    }
                    .font(.system(size: 25))
                    .foregroundStyle(.white)
                    .padding(.trailing, 10)
                    .padding(.top,5)
                    
                    Button(action: {
                        isPickerPresented.toggle()
                    }) {
                        Image(systemName: "list.bullet")
                    }
                    .font(.system(size: 25))
                    .foregroundStyle(.white)
                    .padding(.trailing, 30)
                    .padding(.top,5)
                }
                .padding(.bottom, -20)
             
                List {
                    ForEach(fetchedWords) { word in
                        let color = viewModel.customiseButtonColour(correctTimes: word.correctTimes)
                        NavigationLink(destination: WordDetailView(word: word, viewModel: DeckWordViewModel(), selectedColor: $selectedColor)) {
                            Rectangle()
                                .fill(color)
                                .frame(width:20, height:20)
                                .cornerRadius(5)
                                .padding(.trailing,10)
                            
                            Text(word.word)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        }
                    }
                    .onMove(perform: moveWords)
                }
                .scrollContentBackground(.hidden)
                .actionSheet(isPresented: $isPickerPresented) {
                    ActionSheet(
                        title: Text("Select Sorting Option"),
                        buttons: [
                            .default(Text("By Name(Ascending)")) {
                                selectedSortOption = "Name"
                                fetchedWords.sort { $0.word < $1.word }
                            },
                            .default(Text("By Name (Descending)")) {
                                selectedSortOption = "Name"
                                fetchedWords.sort { $0.word > $1.word }
                            },
                            .default(Text("By Date Added")) {
                                selectedSortOption = "Date Added"
                                fetchedWords.sort { $0.word_order < $1.word_order }
                            },
                            .cancel()
                        ]
                    )
                }
                .toolbar(.hidden, for: .tabBar)
            }
            .onAppear {
                print("Selelcted Deck: \(selectedDeck)")
                
                Task {
                    do {
                        print("Getting all words in the selected deck...")
                        
                        // Assign the selected deck id to a variable
                        selectedDeckId = fetchedDecks[selectedDeck].id
                        
                        // Fetch all the words in the selected deck from the db
                        fetchedWords = try await WordService.shared.getWords(deckId: selectedDeckId)
    
                    } catch {
                        print("Error in fetching words: \(error)")
                    }
                }
            }
            .onChange(of: selectedDeck) {
                Task {
                    do {
                        print("Getting all words in the selected deck!!!")
                        // Assign the selected deck id to a variable
                        selectedDeckId = fetchedDecks[selectedDeck].id
                        
                        // Fetch all the words in the selected deck from the db
                        fetchedWords = try await WordService.shared.getWords(deckId: selectedDeckId)
                        
                    } catch {
                        print("Error in fetching words: \(error)")
                    }
                }
                    
            }
            .background(selectedColor)
        }
    }
        
        

    private func moveWords(indices: IndexSet, newOffset: Int) {
        var reorderedWords = fetchedWords
        reorderedWords.move(fromOffsets: indices, toOffset: newOffset)
        
        for index in reorderedWords.indices {
            reorderedWords[index].word_order = index
            print("Deck Name: \(reorderedWords[index].word), Word Order: \(reorderedWords[index].word_order)")
        }
    
        fetchedWords = reorderedWords
    }
}

#Preview {
    let mockDecks = [
            Deck(id: 1, name: "Deck 1", deckOrder: 1, userId: 1),
            Deck(id: 2, name: "Deck 2", deckOrder: 2, userId: 1)
        ]
    
    WordListView(viewModel: DeckWordViewModel(), deck:  Deck(id: 0, name: "Sample Deck1", deckOrder: 0, userId: 1), currentStep: .constant(0), selectedDeck: .constant(1), selectedColor: .constant(.teal), fetchedDecks: .constant(mockDecks))
}
