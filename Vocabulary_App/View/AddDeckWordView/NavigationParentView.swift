import SwiftUI

struct NavigationParentView: View {
    @State private var currentStep: Int = 0
    @State private var word: String = ""
    @State private var definition: String = ""
    @State private var example: String = ""
    @State private var translation: String = ""
    @State private var note: String = ""
    @Binding var selectedDeck: Int
    @Binding var selectedColor: Color
    @Binding var fetchedDecks : [Deck]
    let deck: Deck
    
    init(deck: Deck, selectedDeck: Binding<Int>,selectedColor: Binding<Color>, fetchedDecks: Binding<[Deck]>) {
        self.deck = deck
        self._selectedDeck = selectedDeck
        self._selectedColor = selectedColor
        self._fetchedDecks = fetchedDecks
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if currentStep == 0 {
                    WordListView(viewModel: DeckWordViewModel(), deck: deck, currentStep: $currentStep, selectedDeck: $selectedDeck, selectedColor: $selectedColor, fetchedDecks: $fetchedDecks)
                } else if currentStep == 1 {
                    WordInputView(viewModel: DeckWordViewModel(), word: $word, definition: $definition, currentStep: $currentStep, selectedColor: $selectedColor)
                } else if currentStep == 2 {
                    ExampleInputView(example: $example, translation: $translation, currentStep: $currentStep, selectedColor: $selectedColor)
                } else if currentStep == 3 {
                    ReviewAndAddView(
                        viewModel: DeckWordViewModel(), word: $word,
                        definition: $definition,
                        example: $example,
                        translation: $translation,
                        currentStep: $currentStep,
                        selectedColor: $selectedColor, selectedDeck: $selectedDeck
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
    NavigationParentView(deck: Deck(id: 0, name: "Sample Deck1", deckOrder: 0, userId: 1), selectedDeck: .constant(1), selectedColor: .constant(.teal), fetchedDecks: .constant(mockDecks))
}
