import SwiftUI

// TO DO LIST 
// 1. Users turn to the next page to see more decks (pagination) : Priority 2
// 2. Users can tick off boxes that shows up when tapping one of the words in the list and then, they can delete the selected words : Priority 3
// 3. Users can sort the list of decks by date added or in alphabetical order, in either ascending or descending order : Priority 2

struct WordListView: View {
    
    @ObservedObject var deck: Deck
    @State private var isWordInputActive : Bool  = false
    @State private var isPickerPresented : Bool = false
    @State private var selectedSortOption : String = "Name"
    @Binding var currentStep: Int
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(deck.words.sorted(by: { $0.wordOrder < $1.wordOrder })) { word in
                    NavigationLink(destination: WordDetailView(word: word)) {
                        Text(word.word)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                    }
                }
                .onMove(perform: moveWords)
            }
            .navigationTitle("All Words")
            .background(.blue.gradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        currentStep =  1
                    }) {
                        Image(systemName: "plus")
                    }
                    .foregroundStyle(.white)
                    .padding(.trailing,10)
             }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPickerPresented.toggle()
                    }) {
                        Image(systemName: "list.bullet")
                    }
                    .foregroundStyle(.white)
                    .padding(.trailing, 10)
                }
            }
            .actionSheet(isPresented: $isPickerPresented) {
                ActionSheet(
                    title: Text("Select Sorting Option"),
                    buttons: [
                        .default(Text("By Name(Ascending)")) {
                            selectedSortOption = "Name"
//                            deck.words.sort { $0.name < $1.name }
                        },
                        .default(Text("By Name (Descending)")) {
                            selectedSortOption = "Name"
//                            deck.words.sort { $0.name > $1.name }
                        },
                        .default(Text("By Date Added")) {
                            selectedSortOption = "Date Added"
//                            deck.words.sort { $0.listOrder < $1.listOrder }
                        },
                        .cancel()
                    ]
                )
            }
            .toolbar(.hidden, for: .tabBar)
        }
    }
        

    private func moveWords(indices: IndexSet, newOffset: Int) {
        var reorderedWords = deck.words
        reorderedWords.move(fromOffsets: indices, toOffset: newOffset)
        
        for index in reorderedWords.indices {
            reorderedWords[index].wordOrder = index
        }
        
        deck.words = reorderedWords
    }
}


#Preview {
    WordListView(deck:  Deck(name: "Sample Deck1", words: [
        Word(word: "Procrastinate", definition: "後回しにする", example: "I procrastinated my assignments, but I finished them in time.", translation: "私は課題を後回しにした。", wordOrder:0),
        Word(word: "Ubiquitous", definition: "どこにでもある", example: "Smartphones are ubiquitous nowadays.", translation: "スマホは至る所にある", wordOrder: 1)
    ], listOrder: 0), currentStep: .constant(0))
}
