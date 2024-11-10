import SwiftUI

struct ResultView: View {
    
    @ObservedObject var viewModel : PlayStudyViewModel
    @State private var isStudyHomeViewActive: Bool = false
    @State private var isPlayStudyViewActive: Bool = false
    @Binding var selectedDeck: Int
    @Binding var wrongWordIndex: [Int]
    
    var body: some View {
        
        VStack {
            // Put a text here
            Text("Check the Result")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.vertical,10)
            
            // Put a list here to dislay the array of words
            List {
                ForEach(wrongWordIndex, id: \.self) { index in
                    Text(viewModel.decks[selectedDeck].words[index].word)
                }
            }
            .padding(.top, -10)
            .scrollContentBackground(.hidden)
            
            // Put a button here to go back to home page
            HStack {
                Button {
                    isStudyHomeViewActive = true
                } label: {
                    Text("Home")
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
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
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                }
                .frame(width: 100, height: 20)
                .padding()
                .background(.white)
                .cornerRadius(10)
                .padding(.vertical,20)
                .navigationDestination(isPresented: $isPlayStudyViewActive) {
                    PlayStudyView(viewModel: PlayStudyViewModel(), selectedDeck: $selectedDeck)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .background(.blue.gradient)
    }
}

#Preview {
    ResultView(viewModel: PlayStudyViewModel(), selectedDeck: .constant(2), wrongWordIndex: .constant([2]))
}
