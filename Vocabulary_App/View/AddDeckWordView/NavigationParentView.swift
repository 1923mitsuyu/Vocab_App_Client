import SwiftUI

struct NavigationParentView: View {
    
    @State var fetchedWords : [Word] = []
    @State private var currentStep: Int = 0
    @State private var word: String = ""
    @State private var definition: String = ""
    @State private var example: String = ""
    @State private var translation: String = ""
    @State private var note: String = ""
    @State private var selectedDeckId : Int = 0
    @Binding var selectedDeck: Int
    @Binding var fetchedDecks : [Deck]
    @Binding var initialSelectedDeck : Int
    
    init(selectedDeck: Binding<Int>, fetchedDecks: Binding<[Deck]>,initialSelectedDeck: Binding<Int>) {
        self._selectedDeck = selectedDeck
        self._fetchedDecks = fetchedDecks
        self._initialSelectedDeck = initialSelectedDeck
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if currentStep == 0 {
                    WordListView(viewModel: DeckWordViewModel(), fetchedWords: $fetchedWords, selectedDeckId: $selectedDeckId, currentStep: $currentStep, selectedDeck: $selectedDeck, fetchedDecks: $fetchedDecks)
                } else if currentStep == 1 {
                    WordInputView(viewModel: DeckWordViewModel(), word: $word, definition: $definition, currentStep: $currentStep, initialSelectedDeck: $initialSelectedDeck, fetchedWords: $fetchedWords)
                } else if currentStep == 2 {
                    ExampleInputView(example: $example, translation: $translation, currentStep: $currentStep)
                } else if currentStep == 3 {
                    ReviewAndAddView(
                        viewModel: DeckWordViewModel(), word: $word,
                        definition: $definition,
                        example: $example,
                        translation: $translation,
                        currentStep: $currentStep,
                        selectedDeck: $selectedDeck,
                        selectedDeckId: $selectedDeckId
                    )
                }
            }
        }
    }
}

#Preview {
    
    let mockDecks = [
            Deck(id: 1, name: "Deck 1", deckOrder: 1, userId: 1),
            Deck(id: 2, name: "Deck 2", deckOrder: 2, userId: 1)
        ]
    NavigationParentView(selectedDeck: .constant(1), fetchedDecks: .constant(mockDecks), initialSelectedDeck: .constant(1))
}
