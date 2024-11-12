import SwiftUI

struct ResultView: View {
    
    @ObservedObject var viewModel: PlayStudyViewModel
    @State private var isStudyHomeViewActive: Bool = false
    @State private var isPlayStudyViewActive: Bool = false
    @State private var isMainViewActive: Bool = false
    @State private var showSheet: Bool = false
    @State private var selectedWordIndex: Int? = nil
    @Binding var selectedDeck: Int
    @Binding var wrongWordIndex: [Int]
    
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
                        Text("\(viewModel.decks[selectedDeck].words[index].word) :")
                        Text(viewModel.decks[selectedDeck].words[index].definition)
                    }
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .onTapGesture {
                        selectedWordIndex = index // Set the selected word index when tapped
                        showSheet = true // Show the sheet
                    }
                    .sheet(isPresented: $showSheet) {
                        if let index = selectedWordIndex {
                            VStack {
                                Spacer()
                                VStack {
                                    Text("例文:")
                                        .font(.system(size: 20, weight: .medium, design: .rounded))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.bottom, 5)
                                        .padding(.horizontal, 10)
                                    
                                    Text("\(viewModel.decks[selectedDeck].words[index].example)")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 10)
                                    
                                }
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .background(.white)
                                .cornerRadius(30)
                                .padding(.horizontal, 5)
                                
                                VStack {
                                    Text("日本語訳:")
                                        .font(.system(size: 20, weight: .medium, design: .rounded))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.bottom, 5)
                                        .padding(.horizontal, 10)
                                    
                                    Text("\(viewModel.decks[selectedDeck].words[index].translation)")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 10)
                                }
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .background(.white)
                                .cornerRadius(30)
                                .padding(.horizontal, 5)
                                
                                Spacer()
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
                    StudyHomeView(viewModel: PlayStudyViewModel())
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .background(.blue.gradient)
    }
}

#Preview {
    ResultView(viewModel: PlayStudyViewModel(), selectedDeck: .constant(2), wrongWordIndex: .constant([0]))
}
