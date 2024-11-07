import SwiftUI

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
        }
    }
}

#Preview {
    WordDetailView(word: Word(word: "Hello", definition: "こんにちは", example: "Hello, how are you?", translation: "こんにちは、元気?"))
}
