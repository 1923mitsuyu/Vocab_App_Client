import SwiftUI

// TO DO LIST 
// 1. Users turn to the next page to see more decks (pagination) : Priority 2
// 2. Users can tick off boxes that shows up when tapping one of the words in the list and then, they can delete the selected words : Priority 3

struct WordListView: View {
    
    @ObservedObject var viewModel : DeckWordViewModel
    @Binding var fetchedWords : [Word]
    @State private var isWordInputActive : Bool  = false
    @State private var isPickerPresented : Bool = false
    @State private var selectedSortOption : String = "Name"
    @State private var isChecked = false
    @Binding var selectedDeckId : Int
    @Binding var currentStep: Int
    @Binding var selectedDeck : Int
    @Binding var selectedColor: Color
    @Binding var fetchedDecks : [Deck]
    @State var initialSelectedDeck : Int = 0
        
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
                        NavigationLink(destination: WordDetailView(word: word, viewModel: DeckWordViewModel(), selectedColor: $selectedColor, fetchedWords: $fetchedWords, selectedDeckId: $selectedDeckId,currentStep: $currentStep, selectedDeck: $selectedDeck, fetchedDecks:$fetchedDecks)) {
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
                                saveNewOrder()
                            },
                            .default(Text("By Name (Descending)")) {
                                selectedSortOption = "Name"
                                fetchedWords.sort { $0.word > $1.word }
                                saveNewOrder()
                            },
                            .default(Text("By Date Added")) {
                                selectedSortOption = "Date Added"
                                fetchedWords.sort { $0.id < $1.id }
                                saveNewOrder()
                            },
                            .cancel()
                        ]
                    )
                }
                .toolbar(.hidden, for: .tabBar)
            }
            .onAppear {
                Task {
                    do {
                        initialSelectedDeck = selectedDeck
                        print("The index of the selected deck \(initialSelectedDeck)")
                        
                        selectedDeckId = fetchedDecks[initialSelectedDeck].id
                        print("The id of the selected deck \(selectedDeckId)")
                        
                        // Fetch all the words in the selected deck from the db
                        fetchedWords = try await WordService.shared.getWords(deckId: selectedDeckId)
                        
                        print("The number of words in the deck: \(fetchedWords.count)")
                        
                        fetchedWords = fetchedWords.sorted { $0.word_order < $1.word_order }
                        
                    } catch {
                        print("Error in fetching words: \(error)")
                    }
                }
            }
            .background(.blue.gradient)
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
        
        let updatedOrder = fetchedWords.map { ["wordId": $0.id, "word_order": $0.word_order] }
        
        print("updatedOrder \(updatedOrder)")
        
        // Call a editing func to update the deck order
        Task {
            do {
                _ = try await WordService.shared.updateWordOrder(updatedOrder)
                
            } catch {
                print("Error in updating the word order: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveNewOrder() {
        for index in fetchedWords.indices {
            fetchedWords[index].word_order = index
            print("Word: \(fetchedWords[index].word), Word Order: \(fetchedWords[index].word_order)")
        }
        
        let updatedOrder = fetchedWords.map { ["wordId": $0.id, "word_order": $0.word_order] }
        
        Task {
            do {
                _ = try await WordService.shared.updateWordOrder(updatedOrder)
            } catch {
                print("Error in updating the word order: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    let mockDecks = [
            Deck(id: 1, name: "Deck 1", deckOrder: 1, userId: 1),
            Deck(id: 2, name: "Deck 2", deckOrder: 2, userId: 1)
        ]
    let mockWords = [    Word(id: 0, word: "Apple", definition: "りんご", example: "I eat an {{apple}} every morning but I did not eat it this morning. I just wanted to eat something different.", translation: "私は毎朝リンゴを食べます。", correctTimes: 0, word_order: 1, deckId: sampleDecks[0].id)]

    
    WordListView(viewModel: DeckWordViewModel(), fetchedWords: .constant(mockWords), selectedDeckId: .constant(1), currentStep: .constant(0), selectedDeck: .constant(1), selectedColor: .constant(.teal), fetchedDecks: .constant(mockDecks))
}
