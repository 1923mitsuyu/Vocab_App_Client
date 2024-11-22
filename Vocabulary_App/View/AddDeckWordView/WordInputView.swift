import SwiftUI

struct WordInputView: View {
    
    @ObservedObject var viewModel: DeckWordViewModel
    @Binding var word: String
    @Binding var definition: String
    @Binding var currentStep: Int
    @State private var activeAlert: Bool = false
    @Binding var selectedColor: Color
    @Binding var initialSelectedDeck : Int
    @FocusState var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height:20)
                
                Text("Add a New Word")
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .padding(.bottom,5)
                
                // Progress bar
                HStack {
                    ForEach(1...3, id: \.self) { step in
                        HStack {
                            Circle()
                                .strokeBorder(step == currentStep ? Color.blue : Color.gray, lineWidth: 2)
                                .background(Circle().foregroundColor(step == currentStep ? Color.blue : Color.white))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text("\(step)")
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
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

                Spacer().frame(height: 20)
                
                TextField("New Word", text: $word)
                    .modifier(TextFieldModifier(height: 30, text: $word))
                    .focused($isFocused)
                
                Spacer().frame(height: 20)
                
                TextField("Translation here", text: $definition)
                    .modifier(TextFieldModifier(height: 30, text: $definition))
                    .focused($isFocused)
            
                Spacer().frame(height: 40)
                       
                HStack {
                    Button {
                        currentStep = 0
                    } label: {
                        Text("Previous")
                    }
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .frame(width:150, height: 50)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .cornerRadius(10)
                
                    Spacer().frame(width: 20)
                    
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
                    }
                    .disabled(word.isEmpty || definition.isEmpty)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .frame(width:150, height: 50)
                    .foregroundStyle(.white)
                    .background(word.isEmpty || definition.isEmpty ? .gray : .blue)
                    .cornerRadius(10)
                    .alert(isPresented: $activeAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text("Please fill in the both blanks"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(selectedColor)
            .onTapGesture {
                isFocused = false
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                print("We are about to navigate back to word list view!!!")
                print(initialSelectedDeck)
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

struct TextFieldModifier: ViewModifier {
    
    var height: CGFloat
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .semibold, design: .rounded))
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
        viewModel: DeckWordViewModel(), word: .constant("Procrastinate"),
        definition: .constant("後回しにする"),
        currentStep: .constant(1), selectedColor: .constant(.teal),
        initialSelectedDeck: .constant(1)
    )
}
