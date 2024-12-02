import SwiftUI

struct WordRearrangementView: View {
    
    @ObservedObject var viewModel: PlayStudyViewModel
    @ObservedObject var viewModel2: DeckWordViewModel
    @State private var modifiedExample : String = ""
    @State private var translation : String = ""
    @State private var options : [String] = []
    @State private var word : String = ""
    @State private var joinedSentence : String = ""
    @Binding var progress : Double
    @Binding var isAnswerCorrect : Bool
    @Binding var showPopup : Bool
    @Binding var randomNum: Int
    @Binding var isResultViewActive: Bool
    @Binding var fetchedWords : [Word]
    @Binding var selectedDeck: Int
    @Binding var userId : Int
    @Binding var fetchedDecks: [Deck]
    @Binding var isFillInTheBlank : Bool
    @Binding var isAlertActive : Bool
    @Binding var isStudyHomeViewActive: Bool
   
    let itemsPerRow = 4
    var onDismiss: () -> Void
    
    let words: [String] = [
            "Short",
            "A bit longer text",
            "This is a",
            "Another label",
            "SwiftUI"
        ]
    
    struct FlowLayout: Layout {
        var spacing: CGFloat = 8
        var leadingPadding: CGFloat = 10
        var trailingPadding: CGFloat = 10
        
        func sizeThatFits(proposal: ProposedViewSize,
                          subviews: Subviews,
                          cache: inout ()) -> CGSize {
            let containerWidth = proposal.width ?? .infinity
            let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
            return layout(sizes: sizes,
                          spacing: spacing,
                          leadingPadding: leadingPadding,
                          trailingPadding: trailingPadding,
                          containerWidth: containerWidth).size
        }
        
        func placeSubviews(in bounds: CGRect,
                           proposal: ProposedViewSize,
                           subviews: Subviews,
                           cache: inout ()) {
            let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
            let offsets =
                layout(sizes: sizes,
                       spacing: spacing,
                       leadingPadding: leadingPadding,
                       trailingPadding: trailingPadding,
                       containerWidth: bounds.width).offsets
            for (offset, subview) in zip(offsets, subviews) {
                subview.place(at: .init(x: offset.x + bounds.minX,
                                        y: offset.y + bounds.minY),
                              proposal: .unspecified)
            }
        }
        
        private func layout(sizes: [CGSize],
                            spacing: CGFloat = 8,
                            leadingPadding: CGFloat = 16,
                            trailingPadding: CGFloat = 16,
                            containerWidth: CGFloat) -> (offsets: [CGPoint], size: CGSize) {
            var result: [CGPoint] = []
            var currentPosition: CGPoint = .init(x: leadingPadding, y: 0) // 初期位置を修正
            var lineHeight: CGFloat = 0
            var maxX: CGFloat = 0
            
            for size in sizes {
                // 改行が必要な場合
                if currentPosition.x + size.width + trailingPadding > containerWidth {
                    currentPosition.x = leadingPadding // 左揃え
                    currentPosition.y += lineHeight + spacing
                    lineHeight = 0
                }
                
                result.append(currentPosition)
                currentPosition.x += size.width + spacing
                maxX = max(maxX, currentPosition.x)
                lineHeight = max(lineHeight, size.height)
            }
            
            // 最終サイズの計算
            return (result,
                    .init(width: containerWidth, height: currentPosition.y + lineHeight))
        }
    } // here
    
    var body: some View {
        
        let columns = [
            GridItem(.adaptive(minimum: 100)),
        ]
        
        NavigationStack {
            VStack{
                
                Spacer().frame(height:20)
                
                VStack(alignment: .leading) {
                    Text("- 日本語訳 - ")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom,5)
                    
                    Text(translation)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                }
                .padding(.leading,15)
                .padding(.bottom,20)
            
                ScrollView{
                    AnyLayout(FlowLayout(spacing: 8, leadingPadding: 10, trailingPadding: 10)) {
                        ForEach(Array(viewModel.arrangedWords.enumerated()), id: \.1) { index, word in
                            Text(word)
                                .padding(20)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .onTapGesture {
                                    viewModel.moveWordOutOfSpace(index: index)
                                    print("Tapped word: \(word), at index: \(index)")
                                    print("Arranged words: \(viewModel.arrangedWords)")
                                }
                        }
                    }
                }
            
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(options.indices, id: \.self) { index in
                            if !viewModel.tappedWordsIndex.contains(index) {
                                Text(options[index])
                                    .padding()
                                    .frame(minWidth: 100)
                                    .background(Rectangle().fill(Color.green.opacity(0.8)))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        if !options.isEmpty{
                                            viewModel.moveWordToSpace(index: index, options: options)
                                            
                                            viewModel.storeTappedWordsIndex(index: index)
                                            
                                            print("arranged words: \(viewModel.arrangedWords)")
                                        }
                                    }
                                    .offset(y: viewModel.tappedWordIndex == index ? -50 : 0)
                                    .animation(.spring(), value: viewModel.tappedWordIndex)
                            }
                            else {
                                Text("")
                                    .padding()
                                    .frame(minWidth: 100, minHeight: 53)
                                    .background(Rectangle().fill(Color.gray.opacity(0.8)))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }
                .frame(height:200)
                
                Spacer().frame(height: 30)
                
                Button {
                    // Join each split word into one string
                    joinedSentence = viewModel.putArrayBackToString()
                    print("The joined Sentecd: \(joinedSentence)")
                    // Check if the answer is correct
                    isAnswerCorrect = viewModel.checkAnswer(userAnswer: joinedSentence, modifiedExample: modifiedExample)
                    print("Correct Answer?: \(isAnswerCorrect)")
                    
                    if isAnswerCorrect {
                        viewModel.usedWordsIndex.append(randomNum)
                        print("The used index:\(viewModel.usedWordsIndex)")
                        fetchedWords[randomNum].correctTimes += 1
                        progress = viewModel.calculateProgress(wordsList: fetchedWords)
                        
                    } else {
                        viewModel.wrongWordsIndex.append(randomNum)
                        print("The wrong word index:\(viewModel.wrongWordsIndex)")
                    }
                    
                    // Show the pop-up
                    showPopup = true
                    
                } label: {
                    Text("Check")
                        .font(.system(size: 23, weight: .semibold, design: .rounded))
                        .frame(width: 300, height:25)
                }
                .disabled(viewModel.arrangedWords.isEmpty)
                .padding()
                .foregroundStyle(viewModel.arrangedWords.isEmpty ? .white : .blue)
                .background(viewModel.arrangedWords.isEmpty ? .gray.opacity(0.8) : .white)
                .cornerRadius(20)
                
            }
            .alert(isPresented: $isAlertActive) {
                Alert(title: Text("Error"), message: Text("The target deck is empty. Please add words to the deck."), dismissButton: .default(Text("OK")) {
                    isStudyHomeViewActive = true
                })
            }
            .navigationDestination(isPresented: $isResultViewActive) {
                ResultView(viewModel: viewModel, viewModel2: viewModel2, fetchedWords: $fetchedWords, selectedDeck: $selectedDeck, wrongWordIndex: $viewModel.wrongWordsIndex, userId: $userId, fetchedDecks: $fetchedDecks)
            }
            .onAppear {
                // Reset the answer every time this view comes in
                viewModel.arrangedWords = []
                viewModel.tappedWordsIndex = []
                if fetchedWords.isEmpty {
                    isAlertActive = true
                    return
                }
                
                Task {
                    do {
                        // Generate a random int to get ready for the first random question
                        randomNum = try await viewModel.generateRandomQuestion(wordsList: fetchedWords)
                        
                        // Remove the bracket and set the first question
                        let original_example = fetchedWords[randomNum].example
                        modifiedExample = viewModel2.removeBrackets(original_example)
                        
                        translation = fetchedWords[randomNum].translation
                        
                        // Split the sentence into the array
                        options = viewModel.sliceSuffleSentence(sentence: modifiedExample)
                        print("Splitted Sentence: \(options)")
                        
                    } catch {
                        print("Error in fetching words: \(error.localizedDescription)")
                    }
                }
            }
            .sheet(isPresented: $showPopup) {
                if isAnswerCorrect {
                    VStack {
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .font(.title)
                            
                            Text("Good Job!")
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                        
                        Button {
                            if viewModel.checkIfAllWordsUsed(wordsList: fetchedWords) {
                                print("Finished all the words in the deck")
                                
                                // Wait for one second and jump to the result view
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                    // Remove the sheet
                                    onDismiss()
                                    // Navigate to the Result View
                                    isResultViewActive = true
                                }
                                
                            } else {
                                // Remove the sheet
                                onDismiss()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isFillInTheBlank.toggle()
                                }
                            }
                        } label: {
                            Text("Continue")
                                .font(.system(size: 23, weight: .semibold, design: .rounded))
                                .frame(maxWidth: 200, maxHeight: 60)
                                .background(.white)
                                .cornerRadius(20)
                        }
                    }
                    .interactiveDismissDisabled(true)
                    .presentationDetents([.fraction(0.35)])
                    .presentationDragIndicator(.hidden)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.green.opacity(0.9))
                }
                else {
                    VStack {
                        HStack {
                            Image(systemName: "xmark.circle")
                                .font(.title)
                            
                            Text("Good Try!")
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        
                        VStack {
                            Text("Correct Answer")
                                .padding(.bottom,10)
                            
                            ScrollView {
                                Text(modifiedExample)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal,10)
                            }
                            .frame(height:40)
                        }
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding(.bottom,35)
                        
                        Button {
                            // Remove the sheet
                            onDismiss()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isFillInTheBlank.toggle()
                            }
                            
                        } label: {
                            Text("Got it")
                                .font(.system(size: 23, weight: .semibold, design: .rounded))
                                .frame(maxWidth: 200, maxHeight: 60)
                                .background(.white)
                                .cornerRadius(20)
                        }
                    }
                    .interactiveDismissDisabled(true)
                    .presentationDetents([.fraction(0.35)])
                    .presentationDragIndicator(.hidden)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.red.opacity(0.9))
                }
            }
            .padding(.bottom,30)
            
            Spacer()
        }
    }
}

#Preview {
    
    let mockDecks = [
        Deck(id: 1, name: "Deck 1", deckOrder: 1, userId: 1),
        Deck(id: 2, name: "Deck 2", deckOrder: 2, userId: 1)
    ]
    
    let mockWords = [Word(id: 0, word: "Apple", definition: "りんご", example: "I eat an {{apple}} every morning but I did not eat it this morning.", translation: "私は毎朝リンゴを食べます。", correctTimes: 0, word_order: 1, deckId: mockDecks[0].id)]
    
    WordRearrangementView(
        viewModel: PlayStudyViewModel(),
        viewModel2: DeckWordViewModel(),
        progress: .constant(1),
        isAnswerCorrect: .constant(false),
        showPopup: .constant(false),
        randomNum: .constant(0),
        isResultViewActive: .constant(false),
        fetchedWords: .constant(mockWords),
        selectedDeck: .constant(1),
        userId: .constant(1),
        fetchedDecks:.constant(mockDecks),
        isFillInTheBlank: .constant(false),
        isAlertActive:.constant(false),
        isStudyHomeViewActive:.constant(false),
        onDismiss: {}
    )
}

