import SwiftUI

struct PlayStudyView: View {
    
    @ObservedObject var viewModel: PlayStudyViewModel
    @ObservedObject var viewModel2: DeckWordViewModel
    @State private var selectedTab: Int = 1
    @State var randomNum : Int = 0
    @State private var isStudyHomeViewActive: Bool = false
    @State private var isResultViewActive: Bool = false
    @State private var isAnswerCorrect: Bool = false
    @State private var showAlert : Bool = false
    @State private var showPopup : Bool = false
    @State private var progress : Double = 0.00
    @State private var modifiedExample : String = ""
    @State private var isAlertActive : Bool = false
    @State private var correctAnswer : String = ""
    @State private var updatedCorrectTimes : Int = 0
    @State private var isFillInTheBlank : Bool = false
    @Binding var fetchedWords : [Word]
    @Binding var selectedDeck: Int
    @Binding var userId : Int
    @Binding var fetchedDecks: [Deck]
    @FocusState var focus: Bool
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                Spacer().frame(height: 20)
                
                // Progress Bar
                HStack{
                    Button {
                        isStudyHomeViewActive = true
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
                    .navigationDestination(isPresented: $isStudyHomeViewActive) {
                        MainView(userId: $userId, selectedTab: $selectedTab)
                    }
                    
                    Spacer().frame(width:20)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 300, height: 15)
                        
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: CGFloat(progress) * 3, height: 20)
                    }
                    .cornerRadius(10)
                    .frame(width: 320)
                    
                }
                .padding(.bottom,5)
                .padding(.trailing,10)
                
                Text("Complete the sentence")
                    .font(.system(size: 23, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 5)
                    .padding(.leading, 17)
                
                if isFillInTheBlank {
                    FillInBlankView(viewModel: viewModel, viewModel2: viewModel2, selectedTab: $selectedTab, randomNum: $randomNum, isStudyHomeViewActive: $isStudyHomeViewActive, isResultViewActive: $isResultViewActive, isAnswerCorrect: $isAnswerCorrect, showAlert: $showAlert, showPopup: $showPopup, progress: $progress, isAlertActive: $isAlertActive, correctAnswer: $correctAnswer, updatedCorrectTimes: $updatedCorrectTimes, isFillInTheBlank: $isFillInTheBlank, fetchedWords: $fetchedWords, selectedDeck: $selectedDeck, userId: $userId, fetchedDecks: $fetchedDecks)
                        
                } else {
                    WordRearrangementView(viewModel: viewModel, viewModel2: viewModel2, progress: $progress, isAnswerCorrect: $isAnswerCorrect, showPopup: $showPopup, randomNum: $randomNum, isResultViewActive: $isResultViewActive, fetchedWords: $fetchedWords, selectedDeck: $selectedDeck, userId: $userId, fetchedDecks: $fetchedDecks, isFillInTheBlank: $isFillInTheBlank, isAlertActive: $isAlertActive,isStudyHomeViewActive: $isStudyHomeViewActive, onDismiss: {
                        withAnimation {
                            showPopup = false
                        }
                    })
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
            .navigationBarBackButtonHidden()
            .animation(.easeInOut(duration: 0.5), value: isFillInTheBlank)
        }
    }
}

#Preview {
    // Create a sample instance of PlayStudyViewModel with a sample deck index
    let sampleViewModel = PlayStudyViewModel()
    let mockDecks = [
            Deck(id: 1, name: "Deck 1", deckOrder: 1, userId: 1),
            Deck(id: 2, name: "Deck 2", deckOrder: 2, userId: 1)
        ]
    
    let mockWords = [Word(id: 0, word: "Apple", definition: "りんご", example: "I eat and eat an {{apple}} every morning.", translation: "私は毎朝リンゴを食べます。", correctTimes: 0, word_order: 1, deckId: sampleDecks[0].id)]
    
    // Pass the sample ViewModel and selectedDeck binding to the preview
    PlayStudyView(viewModel: sampleViewModel, viewModel2: DeckWordViewModel(), fetchedWords: .constant(mockWords), selectedDeck: .constant(0), userId: .constant(1), fetchedDecks: .constant(mockDecks))
}

