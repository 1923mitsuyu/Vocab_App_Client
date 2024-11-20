import Foundation

class Deck: Decodable, Identifiable, Equatable, ObservableObject {
    
    var id: Int
    var name: String
    var deckOrder: Int
    var userId: Int
    
    init(id: Int, name: String, deckOrder: Int, userId: Int) {
        self.id = id
        self.name = name
        self.deckOrder = deckOrder
        self.userId = userId
    }
    
    static func == (lhs: Deck, rhs: Deck) -> Bool {
        lhs.id == rhs.id
    }
}

struct Word: Decodable, Identifiable, Equatable {
    
    var id: Int
    var word: String
    var definition: String
    var example: String
    var translation: String
    var correctTimes : Int
    var word_order: Int
    var deckId: Int
    
    init(id: Int, word: String, definition: String, example: String, translation: String, correctTimes : Int, word_order: Int, deckId : Int) {
        self.id = id
        self.word = word
        self.definition = definition
        self.example = example
        self.translation = translation
        self.correctTimes = correctTimes
        self.word_order = word_order
        self.deckId = deckId
    }
}

let sampleDecks = [
    Deck(id: 0, name: "Deck1", deckOrder: 0, userId: 1),
    Deck(id: 1, name: "Deck2", deckOrder: 1, userId: 1),
    Deck(id: 2, name: "Deck3", deckOrder: 2, userId: 1),
    Deck(id: 3, name: "Deck4", deckOrder: 3, userId: 1),
    Deck(id: 4, name: "Deck5", deckOrder: 4, userId: 1),
    Deck(id: 5, name: "Deck6", deckOrder: 5, userId: 1),
    Deck(id: 6, name: "Deck7", deckOrder: 6, userId: 1),
    Deck(id: 7, name: "Deck8", deckOrder: 7, userId: 1),
    Deck(id: 7, name: "Deck9", deckOrder: 8, userId: 1),
    Deck(id: 8, name: "Deck10", deckOrder: 9, userId: 1),
]

let sampleWords = [
    Word(id: 0, word: "Apple", definition: "りんご", example: "I eat an {{apple}} every morning but I did not eat it this morning. I just wanted to eat something different.", translation: "私は毎朝リンゴを食べます。", correctTimes: 0, word_order: 1, deckId: sampleDecks[0].id),
    Word(id: 1, word: "Book", definition: "本", example: "I borrowed a {{book}} from the library.", translation: "図書館で本を借りました。", correctTimes: 3, word_order: 2, deckId: sampleDecks[0].id),
    Word(id: 2, word: "Chair", definition: "椅子", example: "I need a comfortable {{chair}} for my desk.", translation: "机用に座り心地の良い椅子が必要です。", correctTimes: 2, word_order: 3, deckId: sampleDecks[1].id),
    Word(id: 3, word: "Dog", definition: "犬", example: "My {{dog}} loves going for a walk every evening.", translation: "私の犬は毎晩散歩に行くのが大好きです。", correctTimes: 1, word_order: 1, deckId: sampleDecks[1].id),
    Word(id: 4, word: "Egg", definition: "卵", example: "I had scrambled {{eggs}} for breakfast.", translation: "朝食にスクランブルエッグを食べました。", correctTimes: 0, word_order: 2, deckId: sampleDecks[2].id),
    Word(id: 5, word: "Car", definition: "車", example: "I bought a new {{car}} last week.", translation: "先週、新しい車を買いました。", correctTimes: 0, word_order: 3, deckId: sampleDecks[2].id),
    Word(id: 6, word: "Cat", definition: "猫", example: "My {{cat}} sleeps all day.", translation: "私の猫は一日中寝ています。", correctTimes: 2, word_order: 1, deckId: sampleDecks[3].id),
    Word(id: 7, word: "Water", definition: "水", example: "Drink more {{water}} to stay hydrated.", translation: "水分補給のためにもっと水を飲みましょう。", correctTimes: 5, word_order: 2, deckId: sampleDecks[3].id),
    Word(id: 8, word: "Watch", definition: "時計", example: "I wear a {{watch}} on my wrist.", translation: "私は腕に時計をつけています。", correctTimes: 4, word_order: 3, deckId: sampleDecks[4].id),
    Word(id: 9, word: "Smartphone", definition: "スマホ", example: "{{Smartphones}} are ubiquitous nowadays.", translation: "現代ではスマートフォンがどこにでもあります。", correctTimes: 0, word_order: 1, deckId: sampleDecks[4].id),
]

