import SwiftUI

struct NavigationParentView: View {
    
    @State private var currentStep: Int = 1
    @State private var word: String = ""
    @State private var definition: String = ""
    @State private var example: String = ""
    @State private var translation: String = ""
    @State private var note: String = ""
    @State private var deckId: UUID
    @State private var deckName: String = ""
    let deck: Deck
   
    init(deck: Deck) {
        self.deck = deck
        _deckId = State(initialValue: deck.id)
        _deckName = State(initialValue: deck.name)
    }
    
    var body: some View {
            NavigationStack {
                VStack {
                    if currentStep == 1 {
                        WordInputView(viewModel: DeckViewModel(), word: $word, definition: $definition, currentStep: $currentStep)
                    } else if currentStep == 2 {
                        ExampleInputView(example: $example, translation: $translation, note: $note, currentStep: $currentStep)
                    } else {
                        ReviewAndAddView(
                            word: $word,
                            definition: $definition,
                            example: $example,
                            translation: $translation,
                            note: $note,
                            currentStep: $currentStep,
                            deckId: $deckId,
                            deckName: $deckName
                        )
                    }
                }
            }
        }
    }

#Preview {
    NavigationParentView(deck:  Deck(name: "Sample Deck1", words: [
        Word(word: "Procrastinate", definition: "後回しにする", example: "I procrastinated my assignments, but I finished them in time.", translation: "私は課題を後回しにした。"),
        Word(word: "Ubiquitous", definition: "どこにでもある", example: "Smartphones are ubiquitous nowadays.", translation: "スマホは至る所にある")
    ], listOrder: 0))
}
