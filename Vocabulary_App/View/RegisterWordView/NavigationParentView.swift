import SwiftUI

struct NavigationParentView: View {
    
    @State private var currentStep: Int = 1
    @State private var word: String = ""
    @State private var definition: String = ""
    @State private var example: String = ""
    @State private var translation: String = ""
    @State private var note: String = ""
 
    var body: some View {
            NavigationStack {
                VStack {
                    if currentStep == 1 {
                        WordInputView(word: $word, definition: $definition,currentStep: $currentStep)
                    } else if currentStep == 2 {
                        ExampleInputView(example: $example, translation: $translation, note: $note, currentStep: $currentStep)
                    } else {
                        ReviewAndAddView(
                            word: $word,
                            definition: $definition,
                            example: $example,
                            translation: $translation,
                            note: $note,
                            currentStep: $currentStep
                        )
                    }
                }
            }
        }
    }

#Preview {
    NavigationParentView()
}
