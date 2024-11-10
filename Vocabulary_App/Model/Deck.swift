import Foundation

struct Deck: Identifiable, Equatable {
    
    var id = UUID()
    var name: String
    var words: [Word]
    var listOrder: Int
    
    init(name: String, words: [Word] = [], listOrder: Int) {
        self.name = name
        self.words = words
        self.listOrder = listOrder
    }
    
    static func == (lhs: Deck, rhs: Deck) -> Bool {
        lhs.id == rhs.id
    }
}

struct Word: Identifiable {
    var id = UUID()
    var word: String
    var definition: String
    var example: String
    var translation: String
    
    init(id: UUID = UUID(), word: String, definition: String, example: String, translation: String) {
        self.id = id
        self.word = word
        self.definition = definition
        self.example = example
        self.translation = translation
    }
}

let sampleDecks = [
    Deck(name: "Deck1", words: [
        Word(word: "Study", definition: "勉強する", example: "I am {{studying}} for my exams.", translation: "私はテスト勉強をした。"),
        Word(word: "Run", definition: "走る", example: "I was {{running}} in the ground.", translation: "私はグラウンドを駆け回った。"),
        Word(word: "Stop", definition: "止まる", example: "I did not {{stop}} myself from eating pancakes.", translation: "パンケーキを食べずにはいられなかった。")], listOrder: 0),
    Deck(name: "Deck2", words: [
        Word(word: "Enigmatic", definition: "謎めいた", example: "The {{enigmatic}} smile of the Mona Lisa has intrigued people for centuries.", translation: "モナリザの謎めいた微笑みは何世代にもわたり人々を魅了してきた"),
        Word(word: "Eloquent", definition: "雄弁な", example: "The speaker gave an {{eloquent}} speech that moved the audience.", translation: "そのスピーカーは聴衆を感動させる雄弁なスピーチを行った"),
        Word(word: "Cacophony", definition: "不協和音", example: "The {{cacophony}} of the city made it difficult to concentrate.", translation: "都市の不協和音は集中するのを困難にさせた")], listOrder: 1),
    Deck(name: "Deck3", words: [
        Word(word: "Meticulous", definition: "几帳面な", example: "She is known for her {{meticulous}} attention to detail.", translation: "彼女は細部にまで気を配る几帳面なことで知られている"),
        Word(word: "Ubiquitous", definition: "どこにでもある", example: "Smartphones are {{ubiquitous}} nowadays.", translation: "スマホは至る所にある"),
        Word(word: "Ephemeral", definition: "儚い", example: "The beauty of a sunset is {{ephemeral}} but unforgettable.", translation: "夕日の美しさは儚いが忘れられない")], listOrder: 2),
    Deck(name: "Deck4", words: [
        Word(word: "Euphoria", definition: "幸福感", example: "Winning the championship filled him with {{euphoria}}.", translation: "チャンピオンシップに勝利したことで彼は幸福感で満たされた"),
        Word(word: "Quixotic", definition: "空想的な", example: "His {{quixotic}} ideas often led to unrealistic expectations.", translation: "彼の空想的な考えはしばしば現実的でない期待を生んだ"),
        Word(word: "Camaraderie", definition: "仲間意識", example: "The {{camaraderie}} among teammates was remarkable.", translation: "チームメイト間の仲間意識は素晴らしかった")], listOrder: 3),
    Deck(name: "Deck5", words: [
        Word(word: "Tenacity", definition: "粘り強さ、執念", example: "Her {{tenacity}} helped her achieve her goals.", translation: "彼女の粘り強さが目標達成を助けた。"),
        Word(word: "Eloquent", definition: "雄弁な", example: "The speaker was {{eloquent}} and persuasive.", translation: "スピーカーは雄弁で説得力があった。"),
        Word(word: "Meticulous", definition: "細心の注意を払う", example: "She is {{meticulous}} in her work, never missing a detail.", translation: "彼女は仕事において細心の注意を払い、細部を見逃すことはない。")], listOrder: 4)
]

