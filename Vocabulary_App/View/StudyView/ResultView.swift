import SwiftUI

// TO DO LIST (12/11)
// 全問正解の時に祝福の文を表示するようにする

struct ResultView: View {
    
    @ObservedObject var viewModel : PlayStudyViewModel
    @State private var isStudyHomeViewActive: Bool = false
    @State private var isPlayStudyViewActive: Bool = false
    @Binding var selectedDeck: Int
    @Binding var wrongWordIndex: [Int]
    
    var body: some View {
        
        VStack {
            Text("Check the Result")
                .font(.system(size: 25, weight: .semibold, design: .rounded))
                .padding(.vertical,10)
            
            List {
                ForEach(Array(Set(wrongWordIndex)), id: \.self) { index in
                    Text(viewModel.decks[selectedDeck].words[index].word)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                }
            }
            .padding(.top, -10)
            .scrollContentBackground(.hidden)
            
            HStack {
                Button {
                    isStudyHomeViewActive = true
                } label: {
                    Text("Home")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                       
                }
                .frame(width: 100, height: 20)
                .padding()
                .background(.white)
                .cornerRadius(10)
                .padding(.vertical,20)
                .navigationDestination(isPresented: $isStudyHomeViewActive) {
                    StudyHomeView(viewModel: PlayStudyViewModel())
                }
                
                Spacer().frame(width:30)
                
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
                .padding(.vertical,20)
                .navigationDestination(isPresented: $isPlayStudyViewActive) {
                    PlayStudyView(viewModel: PlayStudyViewModel(), selectedDeck: $selectedDeck)
                }
            }
        }
        .onAppear {
            // call a function to remove all duplicated words here
            // viewModel.getUniqueWords()
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .background(.blue.gradient)
    }
}

#Preview {
    ResultView(viewModel: PlayStudyViewModel(), selectedDeck: .constant(2), wrongWordIndex: .constant([2]))
}


