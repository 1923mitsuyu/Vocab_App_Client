import SwiftUI

struct WordOrderView: View {
    // 選択肢と結果を保持する状態
    @State private var options = [
        "Practice", "makes", "perfect",
        "but", "nobody", "is", "perfect",
        "so", "why", "practice"
    ]
    @State private var arrangedWords: [String] = []
    @State private var tappedWordIndex: Int? = nil
    @State private var progress : Double = 0.00
    var body: some View {
        
        let columns = [
            GridItem(.adaptive(minimum: 100)), // カラムの最小幅を80に設定
        ]
        
        NavigationStack {
            VStack{
                Spacer().frame(height: 10)
                
                HStack{
                    Button {
//                        isStudyHomeViewActive = true
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
//                    .navigationDestination(isPresented: $isStudyHomeViewActive) {
//                      MainView(userId: $userId)
//                    }
                    
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
                // 整列された単語を表示するスペース
                HStack {
                    ForEach(arrangedWords, id: \.self) { word in
                        Text(word)
                            .padding()
                            .background(Capsule().fill(Color.green.opacity(0.7)))
                            .foregroundColor(.white)
                            .animation(.spring(), value: arrangedWords)
                    }
                }
                .frame(height: 70)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(options.indices, id: \.self) { index in
                        if !arrangedWords.contains(options[index]) {
                            Text(options[index])
                                .padding()
                                .frame(minWidth: 100) // カードの最小幅を設定
                                .background(Capsule().fill(Color.blue.opacity(0.7)))
                                .foregroundColor(.white)
                                .onTapGesture {
                                    moveWordToSpace(index: index)
                                }
                                .offset(y: tappedWordIndex == index ? -50 : 0) // アニメーションで上に飛ばす
                                .animation(.spring(), value: tappedWordIndex)
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
        }
    }
    
    // 単語をスペースに移動する処理
    private func moveWordToSpace(index: Int) {
        let word = options[index]
        arrangedWords.append(word)
        tappedWordIndex = index
        
        // 少し遅らせて選択をリセット
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            tappedWordIndex = nil
        }
    }
}


#Preview {
    WordOrderView()
}
