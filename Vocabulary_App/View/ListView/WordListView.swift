import SwiftUI

// TO DO LIST 
// 1. Users turn to the next page to see more decks (pagination) : Priority 2
// 2. Users can tick off boxes that shows up when tapping one of the words in the list and then, they can delete the selected words : Priority 3

struct WordListView: View {
    
    @ObservedObject var viewModel : DeckWordViewModel
    @ObservedObject var deck: Deck
    @Binding var selectedDeck : Int
    @State var wordList : [Word] = []
    @State private var isWordInputActive : Bool  = false
    @State private var isPickerPresented : Bool = false
    @State private var selectedSortOption : String = "Name"
    @State private var isChecked = false
    @Binding var currentStep: Int
    @Binding var selectedColor: Color
        
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
                    ForEach(wordList) { word in
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
                                wordList.sort { $0.word < $1.word }
                            },
                            .default(Text("By Name (Descending)")) {
                                selectedSortOption = "Name"
                                wordList.sort { $0.word > $1.word }
                            },
                            .default(Text("By Date Added")) {
                                selectedSortOption = "Date Added"
                                wordList.sort { $0.wordOrder < $1.wordOrder }
                            },
                            .cancel()
                        ]
                    )
                }
                .toolbar(.hidden, for: .tabBar)
            }
            .onAppear {
                wordList = viewModel.filterWords(for: viewModel.decks[selectedDeck].id, in: viewModel.words)
            }
            .onChange(of: selectedDeck) { 
                wordList = viewModel.filterWords(for: viewModel.decks[selectedDeck].id, in: viewModel.words)
            }
            .background(selectedColor)
        }
    }
        

    private func moveWords(indices: IndexSet, newOffset: Int) {
        var reorderedWords = wordList
        reorderedWords.move(fromOffsets: indices, toOffset: newOffset)
        
        for index in reorderedWords.indices {
            reorderedWords[index].wordOrder = index
            print("Deck Name: \(reorderedWords[index].word), Word Order: \(reorderedWords[index].wordOrder)")
        }
    
        wordList = reorderedWords
    }
}

#Preview {
    WordListView(viewModel: DeckWordViewModel(), deck:  Deck(id: 0, name: "Sample Deck1", deckOrder: 0, userId: 1), selectedDeck: .constant(1), currentStep: .constant(0), selectedColor: .constant(.teal))
}
