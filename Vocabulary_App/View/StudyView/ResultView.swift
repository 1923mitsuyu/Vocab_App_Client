import SwiftUI

struct ResultView: View {
    
    @ObservedObject var viewModel: PlayStudyViewModel
    @ObservedObject var viewModel2: DeckWordViewModel
    @Binding var wordList : [Word]
    @State private var isStudyHomeViewActive: Bool = false
    @State private var isPlayStudyViewActive: Bool = false
    @State private var isMainViewActive: Bool = false
    @State private var showSheet: Bool = false
    @State private var selectedWordIndex: Int? = nil
    @State private var modifiedExample : String = ""
    @Binding var selectedDeck: Int
    @Binding var wrongWordIndex: [Int]
    @Binding var selectedColor: Color

    // Helper function to get unique indices while preserving order
    func unique<T: Equatable>(array: [T]) -> [T] {
        var uniqueArray = [T]()
        for item in array {
            if !uniqueArray.contains(item) {
                uniqueArray.append(item)
            }
        }
        return uniqueArray
    }
    
    var body: some View {
        VStack {
            Text("Check the Result")
                .font(.system(size: 25, weight: .semibold, design: .rounded))
                .padding(.vertical, 10)
            
            if wrongWordIndex.count == 0 {
                VStack {
                    Text("Congratulations!")
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    Text("You answered all words correctly!")
                        .foregroundColor(.white)
                }
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(.top, 50)
            }
            
            List {
                // Using unique to preserve the order of indices and remove duplicates
                ForEach(unique(array: wrongWordIndex), id: \.self) { index in
                    HStack {
                        Text("\(wordList[index].word) :")
                        Text(wordList[index].definition)
                    }
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .onTapGesture {
                        selectedWordIndex = index // Set the selected word index when tapped
                        showSheet = true // Show the sheet
                        
                    }
                    .sheet(isPresented: $showSheet) {
                        if let index = selectedWordIndex {
                            VStack {
                                VStack {
                                    Text("例文:")
                                        .font(.system(size: 20, weight: .medium, design: .rounded))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.bottom, 5)
                                        .padding(.top, 40)
                                        .padding(.horizontal, 10)
                                    
                                    ScrollView {
                                        Text("\(modifiedExample)")
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 10)
                                            .padding(.bottom,20)
                                    }
                                  
                                    Divider()
                                    
                                    Text("日本語訳:")
                                        .font(.system(size: 20, weight: .medium, design: .rounded))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.bottom, 5)
                                        .padding(.top,10)
                                        .padding(.horizontal, 10)
                                    
                                    ScrollView {
                                        Text("\(wordList[index].translation)")
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 10)
                                    }
                                }
                                .onAppear {
                                    modifiedExample = viewModel2.removeBrackets(wordList[index].example)
                                }
                                .frame(maxWidth: .infinity, maxHeight: 370)
                                .padding(.horizontal,5)
                                .background(.white)
                                .cornerRadius(30)
                                .padding(.horizontal, 5)
                                .padding(.top,20)
                            }
                            .presentationDetents([.height(350)])
                            .presentationDragIndicator(.visible)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.secondary.opacity(0.4))
                        }
                    }
                }
            }
            .padding(.top, -10)
            .scrollContentBackground(.hidden)
            
            HStack {
                Button {
                    isMainViewActive = true
                } label: {
                    Text("Home")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                    
                }
                .frame(width: 100, height: 20)
                .padding()
                .background(.white)
                .cornerRadius(10)
                .padding(.vertical, 20)
                .navigationDestination(isPresented: $isMainViewActive) {
                    MainView()
                }
                
                Spacer().frame(width: 30)
                
                Button {
                    isPlayStudyViewActive = true
                } label: {
                    Text("Study Again")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                    
                }
                .frame(width: 120, height: 20)
                .padding()
                .background(.white)
                .cornerRadius(10)
                .padding(.vertical, 20)
                .navigationDestination(isPresented: $isPlayStudyViewActive) {
                    StudyHomeView(viewModel: PlayStudyViewModel(), selectedColor: $selectedColor)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .background(selectedColor)
    }
}

#Preview {
    @Previewable @State var sampleWordList: [Word] = [
        Word(id: UUID(), word: "example", definition: "a representative form or pattern", example: "This is an example sentence.", translation: "例", correctTimes: 2, wordOrder: 1, deckId: UUID())
    ]
    @Previewable @State var sampleWrongWordIndex: [Int] = [0]
    @Previewable @State var sampleSelectedDeck: Int = 2

    ResultView(
        viewModel: PlayStudyViewModel(),
        viewModel2: DeckWordViewModel(),
        wordList: $sampleWordList,
        selectedDeck: $sampleSelectedDeck,
        wrongWordIndex: $sampleWrongWordIndex,
        selectedColor: .constant(.teal)
    )
}
