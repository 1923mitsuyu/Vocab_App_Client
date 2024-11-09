import SwiftUI

// TO DO LIST
// ターゲットの単語の部分を空欄or見えなくする : 条件分岐(words[~].wordと一致していたら見えなくする??)
// Deckの中の単語からランダムで選ぶようにする : let randomInt = Int.random(in: 1..<5)使えるかな??
// Deckの中の単語を全部順に出題されるようにする : decksから順に取り出して、0になったらおしまい??
// 正解かどうかの判定をできるようにする : words[~].wordと一致していたら正解??
// 正解ならCorrect!みたいなポップアップを表示 : Bool値使って、正解なら toggle()??

struct PlayStudyView: View {
    
 
    @State private var decks: [Deck] = sampleDecks
    @Binding var selectedDeck: Int
    @State private var writtenAnswer: String = ""
    @State private var progress = 0.1
    @State private var isStudyHomeViewActive: Bool = false
    @State private var isResuktViewActive: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer().frame(height: 30)
                
                ProgressView(value: progress)
                    .frame(width: 320)
                    .accentColor(.white)
                    .padding(.bottom,20)
                
                Text("Read and answer the question")
                    .font( .system(size: 23))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom,30)
                    .padding(.leading, 10)
                
                Text(decks[selectedDeck].words[0].example)
                    .fontWeight(.semibold)
                    .font( .system(size: 15))
                    .frame(maxWidth: 360, alignment: .leading)
                    .padding(.leading, 10)
                    .padding(.vertical,25)
                    .background(.white)
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
                
                Spacer().frame(height: 30)
                Text("Complete the sentence!")
                    .font( .system(size: 23))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 5)
                    .padding(.leading, 10)
                
                TextField("Write your answer here!", text: $writtenAnswer)
                    .padding()
                    .background(Color.white)
                    .frame(width:300)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .padding(.horizontal)
                    .padding(.vertical,10)
                    .onChange(of: writtenAnswer) {
                        print("\(writtenAnswer) is entered")
                    }
                Spacer()
                
                HStack{
                    Button {
                        isStudyHomeViewActive = true
                    } label: {
                        Text("Quit")
                            .fontWeight(.semibold)
                            .frame(width: 80, height:30)
                    }
                    .padding()
                    .foregroundStyle(.black)
                    .background(.white)
                    .cornerRadius(20)
                    .navigationDestination(isPresented: $isStudyHomeViewActive) {
                        StudyHomeView()
                    }
                    Spacer().frame(width: 25)
                    Button {
                        isResuktViewActive = true
                    } label: {
                        Text("Check")
                            .fontWeight(.semibold)
                            .frame(width: 80, height:30)
                    }
                    .padding()
                    .foregroundStyle(.black)
                    .background(.white)
                    .cornerRadius(20)
                    .navigationDestination(isPresented: $isResuktViewActive) {
                        ResultView(selectedDeck: $selectedDeck)
                    }
                }
                Spacer().frame(height: 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    PlayStudyView(selectedDeck: .constant(0))
}


