import SwiftUI

// TO DO List (8/11)
// Users select "edit" and then they can edit the word in the modal (Put)
// Users select "delete" and then they can delete the word in the view (DELETE)
// Users can see the word info in the list

struct WordDetailView: View {
    let word: Word
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(word.word)
                Text(word.definition)
                Text(word.example)
                Text(word.translation)
            }
            .navigationTitle("Word Details")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
        }
    }
}

#Preview {
    WordDetailView(word: Word(word: "Hello", definition: "こんにちは", example: "Hello, how are you?", translation: "こんにちは、元気?"))
}
