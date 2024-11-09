import SwiftUI

struct ResultView: View {
    
    // Declare an array to store all the words they answered incorrectly
    @State private var incorrectWords: [String] = [
        "Apple", "Grape", "Banana", "Pineapple", "Strawberry",
        "Orange", "Watermelon", "Blueberry", "Mango", "Peach",
        "Lemon", "Lime", "Cherry", "Coconut", "Papaya",
        "Pear", "Plum", "Apricot", "Kiwi", "Fig",
        "Guava", "Pomegranate", "Cranberry", "Date", "Jackfruit", "Durian", "Nectarine"
    ]
    
    @State private var isStudyHomeViewActive: Bool = false
    @State private var isPlayStudyViewActive: Bool = false
    @Binding var selectedDeck: Int
    
    var body: some View {
        
        VStack {
            // Put a text here
            Text("Check the Result")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.vertical,10)
            
            // Put a list here to dislay the array of words
            List {
                ForEach(incorrectWords, id: \.self) { word in
                    Text(word)
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
                    StudyHomeView()
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
                    PlayStudyView(selectedDeck: $selectedDeck)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .background(.blue.gradient)
    }
}

#Preview {
    ResultView(selectedDeck: .constant(2))
}
