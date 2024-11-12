import SwiftUI

// TO DO LIST (12/11)
// 全問正解の時に祝福の文を表示するようにする

struct ResultView: View {
    
    @ObservedObject var viewModel : PlayStudyViewModel
    @State private var isStudyHomeViewActive: Bool = false
    @State private var isPlayStudyViewActive: Bool = false
    @State private var showSheet: Bool = false
    @Binding var selectedDeck: Int
    @Binding var wrongWordIndex: [Int]
    
    var body: some View {
        
        VStack {
            Text("Check the Result")
                .font(.system(size: 25, weight: .semibold, design: .rounded))
                .padding(.vertical,10)
            
            List {
                ForEach(Array(Set(wrongWordIndex)), id: \.self) { index in
                    HStack {
                        Text("\(viewModel.decks[selectedDeck].words[index].word) :")
                        Text(viewModel.decks[selectedDeck].words[index].definition)
                    }
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .onTapGesture {
                        showSheet = true
                    }
                    .sheet(isPresented: $showSheet) {
                        VStack {
                            
                            Spacer()
                        
                            VStack {
                                Text("例文:")
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom,5)
                                    .padding(.horizontal, 10)
                                
                                Text("\(viewModel.decks[selectedDeck].words[index].example)")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 10)
                                
                            }
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .background(.white)
                            .cornerRadius(30)
                            .padding(.horizontal,5)
                            
                            VStack {
                                Text("日本語訳:")
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom,5)
                                    .padding(.horizontal, 10)
                                
                                Text("\(viewModel.decks[selectedDeck].words[index].translation)")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 10)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .background(.white)
                            .cornerRadius(30)
                            .padding(.horizontal,5)
                            
                            Spacer()
                        }
                        .presentationDetents([.height(350)])
                        .presentationDragIndicator(.visible)
                        .frame(width: .infinity, height: .infinity)
                        .background(.secondary.opacity(0.4))
                      
                    }
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
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .background(.blue.gradient)
    }
}

#Preview {
    ResultView(viewModel: PlayStudyViewModel(), selectedDeck: .constant(2), wrongWordIndex: .constant([2]))
}


