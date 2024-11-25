//struct CustomSheet1View: View {
//    @Binding var isAnswerCorrect: Bool
//    var correctAnswer: String
//    var onDismiss: () -> Void
//
//    var body: some View {
//        VStack(spacing: 20) {
//            if isAnswerCorrect {
//                HStack {
//                    Image(systemName: "checkmark.circle")
//                        .font(.title)
//                    Text("Good Job!")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                }
//                .padding()
//                .background(Color.green.opacity(0.3))
//                .cornerRadius(10)
//            } else {
//                HStack {
//                    Image(systemName: "xmark.circle")
//                        .font(.title)
//                    Text("Good Try!")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                }
//                .padding()
//                .background(Color.red.opacity(0.3))
//                .cornerRadius(10)
//
//                Text("Correct Answer: \(correctAnswer)")
//                    .font(.body)
//            }
//
//            Button("Continue") {
//                onDismiss()
//            }
//            .font(.title2)
//            .padding()
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(.systemBackground))
//        .cornerRadius(15, corners: [.topLeft, .topRight])
//        .presentationDetents([.medium]) // シートの高さを固定
//        .presentationDragIndicator(.hidden) // ドラッグインジケーターを非表示
//    }
//}
//
//// 角丸を特定の角だけに適用するためのModifier
//struct CornerRadiusStyle: Shape {
//    var radius: CGFloat
//    var corners: UIRectCorner
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(
//            roundedRect: rect,
//            byRoundingCorners: corners,
//            cornerRadii: CGSize(width: radius, height: radius)
//        )
//        return Path(path.cgPath)
//    }
//}
//
//extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape(CornerRadiusStyle(radius: radius, corners: corners))
//    }
//}
//
//#Preview {
//    ContentView()
//}

//import SwiftUI
//
//struct WordOrderView: View {
//    // 選択肢と結果を保持する状態
//    @State private var options = [
//        "Practice", "makes", "perfect",
//        "but", "nobody", "is", "perfect",
//        "so", "why", "practice"
//    ]
//    @State private var arrangedWords: [String] = []
//    @State private var tappedWordIndex: Int? = nil
//    @State private var progress : Double = 0.00
//    @State private var translation : String = "練習は完璧を作る、でも誰も完璧ではない。じゃあ、なぜ練習するの?"
//    var body: some View {
//        
//        let columns = [
//            GridItem(.adaptive(minimum: 100)), // カラムの最小幅を80に設定
//        ]
//        
//        NavigationStack {
//            VStack{
//                Spacer().frame(height: 10)
//                
//                HStack{
//                    Button {
//                        //                        isStudyHomeViewActive = true
//                    } label: {
//                        Image(systemName: "xmark")
//                            .foregroundStyle(.white)
//                    }
//                    //                    .navigationDestination(isPresented: $isStudyHomeViewActive) {
//                    //                      MainView(userId: $userId)
//                    //                    }
//                    
//                    Spacer().frame(width:20)
//                    
//                    ZStack(alignment: .leading) {
//                        Rectangle()
//                            .fill(Color.gray.opacity(0.3))
//                            .frame(width: 300, height: 15)
//                        
//                        Rectangle()
//                            .fill(Color.blue)
//                            .frame(width: CGFloat(progress) * 3, height: 20)
//                    }
//                    .cornerRadius(10)
//                    .frame(width: 320)
//                    
//                }
//                .padding(.bottom,5)
//                .padding(.trailing,10)
//                
//                Text("Complete the sentence")
//                    .font(.system(size: 23, weight: .bold, design: .rounded))
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.vertical, 15)
//                    .padding(.leading, 17)
//                
//                VStack {
//                    Text("- 日本語訳 - ")
//                        .font(.system(size: 17, weight: .bold, design: .rounded))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.leading,14)
//                        .padding(.bottom,5)
//                    
//                    Text(translation)
//                        .font(.system(size: 15, weight: .bold, design: .rounded))
//                        .padding(.horizontal, 10)
//                }
//                
//                // 整列された単語を表示するスペース
//                HStack {
//                    ForEach(arrangedWords, id: \.self) { word in
//                        Text(word)
//                            .padding()
//                            .background(Capsule().fill(Color.green.opacity(0.7)))
//                            .foregroundColor(.white)
//                            .animation(.spring(), value: arrangedWords)
//                    }
//                }
//                .frame(height: 70)
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(10)
//                
//                ScrollView {
//                    LazyVGrid(columns: columns, spacing: 10) {
//                        ForEach(options.indices, id: \.self) { index in
//                            if !arrangedWords.contains(options[index]) {
//                                Text(options[index])
//                                    .padding()
//                                    .frame(minWidth: 100) // カードの最小幅を設定
//                                    .background(Capsule().fill(Color.blue.opacity(0.7)))
//                                    .foregroundColor(.white)
//                                    .onTapGesture {
//                                        moveWordToSpace(index: index)
//                                    }
//                                    .offset(y: tappedWordIndex == index ? -50 : 0) // アニメーションで上に飛ばす
//                                    .animation(.spring(), value: tappedWordIndex)
//                            }
//                        }
//                    }
//                    .padding()
//                    Spacer()
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(.blue.gradient)
//        }
//    }
//    
//    // 単語をスペースに移動する処理
//    private func moveWordToSpace(index: Int) {
//        let word = options[index]
//        arrangedWords.append(word)
//        tappedWordIndex = index
//        
//        // 少し遅らせて選択をリセット
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            tappedWordIndex = nil
//        }
//    }
//}
//
//
//#Preview {
//    WordOrderView()
//}
