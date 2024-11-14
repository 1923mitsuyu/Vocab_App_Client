import Foundation

class Deck: Decodable, Identifiable, Equatable, ObservableObject {
    
    var id = UUID()
    var name: String
    var words: [Word]
    var listOrder: Int
    var userId: Int
    
    init(id: UUID = UUID(), name: String, words: [Word] = [], listOrder: Int, userId: Int) {
        self.id = id
        self.name = name
        self.words = words
        self.listOrder = listOrder
        self.userId = userId
    }
    
    static func == (lhs: Deck, rhs: Deck) -> Bool {
        lhs.id == rhs.id
    }
}

struct Word: Decodable, Identifiable, Equatable {
    
    var id = UUID()
    var word: String
    var definition: String
    var example: String
    var translation: String
    var wordOrder: Int
    var deckId: Int
    
    init(id: UUID = UUID(), word: String, definition: String, example: String, translation: String, wordOrder: Int, deckId : Int) {
        self.id = id
        self.word = word
        self.definition = definition
        self.example = example
        self.translation = translation
        self.wordOrder = wordOrder
        self.deckId = deckId
    }
}

let sampleDecks = [
    Deck(name: "Deck1", words: [
        Word(word: "Study", definition: "勉強する", example: "I am {{studying}} for my exams.", translation: "私はテスト勉強をしています。", wordOrder:0, deckId: 1),
        Word(word: "Run", definition: "走る", example: "I was {{running}} in the ground.", translation: "私はグラウンドを駆け回った。", wordOrder:1, deckId: 1),
        Word(word: "Stop", definition: "止まる", example: "I did not {{stop}} myself from eating pancakes.", translation: "パンケーキを食べずにはいられなかった。", wordOrder:2, deckId: 1)], listOrder: 0, userId: 1),
    Deck(name: "Deck2", words: [
        Word(word: "Study", definition: "勉強する", example: "I am {{studying}} for my exams.", translation: "私はテスト勉強をしています。", wordOrder:0, deckId: 2),
        Word(word: "Run", definition: "走る", example: "I was {{running}} in the ground.", translation: "私はグラウンドを駆け回った。", wordOrder:1, deckId: 2),
        Word(word: "Stop", definition: "止まる", example: "I did not {{stop}} myself from eating pancakes.", translation: "パンケーキを食べずにはいられなかった。", wordOrder:2, deckId: 2)], listOrder: 0, userId: 1),
    Deck(name: "Deck3", words: [
        Word(word: "Study", definition: "勉強する", example: "I am {{studying}} for my exams.", translation: "私はテスト勉強をしています。", wordOrder:0, deckId: 3),
        Word(word: "Run", definition: "走る", example: "I was {{running}} in the ground.", translation: "私はグラウンドを駆け回った。", wordOrder:1, deckId: 3),
        Word(word: "Stop", definition: "止まる", example: "I did not {{stop}} myself from eating pancakes.", translation: "パンケーキを食べずにはいられなかった。", wordOrder:2, deckId: 3)], listOrder: 0, userId: 1),
    Deck(name: "Deck4", words: [
        Word(word: "Study", definition: "勉強する", example: "I am {{studying}} for my exams.", translation: "私はテスト勉強をしています。", wordOrder:0, deckId: 4),
        Word(word: "Run", definition: "走る", example: "I was {{running}} in the ground.", translation: "私はグラウンドを駆け回った。", wordOrder:1, deckId: 4),
        Word(word: "Stop", definition: "止まる", example: "I did not {{stop}} myself from eating pancakes.", translation: "パンケーキを食べずにはいられなかった。", wordOrder:2, deckId: 4)], listOrder: 0, userId: 1),
    Deck(name: "Deck5", words: [
        Word(word: "Study", definition: "勉強する", example: "I am {{studying}} for my exams.", translation: "私はテスト勉強をしています。", wordOrder:0, deckId: 5),
        Word(word: "Run", definition: "走る", example: "I was {{running}} in the ground.", translation: "私はグラウンドを駆け回った。", wordOrder:1, deckId: 5),
        Word(word: "Stop", definition: "止まる", example: "I did not {{stop}} myself from eating pancakes.", translation: "パンケーキを食べずにはいられなかった。", wordOrder:2, deckId: 5)], listOrder: 0, userId: 1),
]

