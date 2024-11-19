import SwiftUI

struct NavigationParentView: View {
    @State private var currentStep: Int = 0
    @State private var word: String = ""
    @State private var definition: String = ""
    @State private var example: String = ""
    @State private var translation: String = ""
    @State private var note: String = ""
    @State private var deckId: UUID
    @State private var deckName: String
    @Binding var selectedDeck: Int
    @Binding var selectedColor: Color
    let deck: Deck
    
    init(deck: Deck, selectedDeck: Binding<Int>,selectedColor: Binding<Color> ) {
        self.deck = deck
        self._selectedDeck = selectedDeck
        self._selectedColor = selectedColor
        _deckId = State(initialValue: deck.id)
        _deckName = State(initialValue: deck.name)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if currentStep == 0 {
                    WordListView(viewModel: DeckWordViewModel(), deck: deck, selectedDeck: $selectedDeck, currentStep: $currentStep, selectedColor: $selectedColor)
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
                        deckId: $deckId,
                        deckName: $deckName,
                        selectedColor: $selectedColor
                    )
                }
            }
        }
    }
}

#Preview {
    NavigationParentView(deck: Deck(name: "Sample Deck1", deckOrder: 0, userId: 1), selectedDeck: .constant(1), selectedColor: .constant(.teal))
}
