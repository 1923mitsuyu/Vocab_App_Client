import SwiftUI

// TO DO LIST
// 1. Users cannnot add a new word that has already existed

struct WordInputView: View {
    
    @ObservedObject var viewModel: DeckViewModel
    @Binding var word: String
    @Binding var definition: String
    @Binding var currentStep: Int
    @State private var activeAlert: Bool = false
    @FocusState var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height:10)
                Text("Add a New Word")
                    .fontWeight(.semibold)
                    .font(. system(size: 25))
                    .padding(.bottom,5)
                
                HStack {
                    ForEach(1...3, id: \.self) { step in
                        HStack {
                            Circle()
                                .strokeBorder(step == currentStep ? Color.blue : Color.gray, lineWidth: 2)
                                .background(Circle().foregroundColor(step == currentStep ? Color.blue : Color.white))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text("\(step)")
                                        .foregroundColor(step == currentStep ? Color.white : Color.gray)
                                        .font(.headline)
                                )
                            
                            // Connecting line except after the last step
                            if step < 3 {
                                Rectangle()
                                    .fill(step < currentStep ? Color.blue : Color.gray)
                                    .frame(height: 2)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity).padding()

                TextField("New Word", text: $word)
                    .modifier(TextFieldModifier(height: 30, text: $word))
                    .focused($isFocused)
                
                Spacer().frame(height: 40)
                
                TextField("Translation here", text: $definition)
                    .modifier(TextFieldModifier(height: 30, text: $definition))
                    .focused($isFocused)
            
                Spacer().frame(height: 40)
                         
                Button {
                    if word.isEmpty || definition.isEmpty {
                        activeAlert = true
                    }
                    else if viewModel.checkIfWordExists(word){
                        print("The word \(word) already exists.")
                    }
                    else {
                        currentStep = 2
                    }
                } label: {
                     Text("Next")
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.size.width / 6 * 2,height: UIScreen.main.bounds.size.width / 10 * 1)
                }
                .background(.white)
                .cornerRadius(10)
                .alert(isPresented: $activeAlert) {
                    Alert(
                           title: Text("Error"),
                           message: Text("Please fill in the both blanks"),
                           dismissButton: .default(Text("OK"))
                       )
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
            .onTapGesture {
                isFocused = false
            }
        }
    }
}

struct TextFieldModifier: ViewModifier {
    
    var height: CGFloat
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .frame(width: 300, height: height)
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 2)
                    
                    HStack {
                        Spacer()
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "delete.left")
                                    .foregroundColor(Color(UIColor.opaqueSeparator))
                            }
                            .padding(.trailing, 15)
                        }
                    }
                }
            )
            .padding(.horizontal)
    }
}
#Preview {
    WordInputView(
        viewModel: DeckViewModel(), word: .constant("Procrastinate"),
        definition: .constant("後回しにする"),
        currentStep: .constant(1)
    )
}

