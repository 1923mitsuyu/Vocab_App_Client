import SwiftUI

struct ExampleInputView: View {
    
    @Binding var example: String
    @Binding var translation: String
    @Binding var note: String
    @Binding var currentStep: Int
    @State private var isReviewAndAddActive: Bool = false
    @State private var activeAlert: Bool = false
    @FocusState var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height:10)
                Text("Add an Example")
                    .fontWeight(.semibold)
                    .font(. system(size: 25))
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
                
                HStack {
                    TextEditor(text: $example)
                        .frame(width: 330, height: 80)
                        .cornerRadius(5)
                        .focused($isFocused)
                        .padding(.leading, 10)
                        .overlay(alignment: .topLeading) {
                            if example.isEmpty {
                                Text("Example sentence here")
                                    .allowsHitTesting(false)
                                    .foregroundColor(Color(uiColor: .placeholderText))
                                    .padding(.leading, 15)
                                    .padding(.top, 8)
                            }
                        }
                    
                    Spacer().frame(width: 10)
                    
                    Button(action: {
                        example = ""
                    }) {
                        Image(systemName: "delete.left")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                    .padding(.top, 4)
                    .opacity(example.isEmpty ? 0 : 1)
                }

                Spacer().frame(height: 10)
                
                Button {
                    print("Button tapped")
                } label: {
                    Text("Generate an example sentence")
                        .font(. system(size: 15))
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .frame(width: 250)
                        .padding(.vertical,5)
                }
                .background(
                    Color.blue
                        .overlay(.black.opacity(0.2))
                )
                .cornerRadius(10)
                
                Spacer().frame(height: 20)
                
                HStack {
                    TextEditor(text: $translation)
                        .frame(width: 330, height: 80)
                        .cornerRadius(5)
                        .padding(.leading,10)
                        .focused($isFocused)
                        .overlay(alignment: .topLeading) {
                            if translation.isEmpty {
                                Text("Example translation here")
                                    .allowsHitTesting(false)
                                    .foregroundColor(Color(uiColor: .placeholderText))
                                    .padding(.leading,15)
                                    .padding(.top, 8)
                            }
                        }
                    
                    Button(action: {
                        translation = ""
                    }) {
                        Image(systemName: "delete.left")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                    .padding(.top, 4)
                    .opacity(translation.isEmpty ? 0 : 1)
                    
                }
                
                Spacer().frame(height: 10)
                
                Button {
                    print("Button tapped")
                } label: {
                    Text("Generate a translation")
                        .font(. system(size: 15))
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .frame(width: 250)
                        .padding(.vertical,5)
                }
                .background(
                    Color.blue
                        .overlay(.black.opacity(0.2))
                )
                .cornerRadius(10)
                
                Spacer().frame(height: 20)
                
                HStack {
                    TextEditor(text: $note)
                        .frame(width: 330, height: 100)
                        .cornerRadius(5)
                        .padding(.leading,10)
                        .focused($isFocused)
                        .overlay(alignment: .topLeading) {
                            if note.isEmpty {
                                Text("Notes")
                                    .allowsHitTesting(false)
                                    .foregroundColor(Color(uiColor: .placeholderText))
                                    .padding(.leading,15)
                                    .padding(.top, 8)
                            }
                        }
                    
                    Button(action: {
                        note = ""
                    }) {
                        Image(systemName: "delete.left")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                    .padding(.top, 4)
                    .opacity(note.isEmpty ? 0 : 1)
                }
                
                Spacer().frame(height: 40)
                
                HStack {
                    Button {
                        currentStep = 1
                    } label: {
                        Text("Previous")
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                            .frame(width: UIScreen.main.bounds.size.width / 6 * 2,height: UIScreen.main.bounds.size.width / 10 * 1)
                    }
                    .background(.white)
                    .cornerRadius(10)
                    
                    Spacer().frame(width: 30)
                    
                    Button {
                        if example.isEmpty || translation.isEmpty {
                            activeAlert = true
                        } else {
                            currentStep = 3
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
                               message: Text("Please fill in the first two blanks")
                           )
                    }
                    
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
            .navigationBarBackButtonHidden()
            .onTapGesture {
                isFocused = false
            }
        }
    }
}


#Preview {
    ExampleInputView(
        example: .constant("I tend to procrastinate and start to work on assessments in the last minutes before they are due."),
        translation: .constant("私は後回しにすることが多く、締め切り直前に課題に取り掛かります。"),
        note: .constant("りんごはおいしいよ"),
        currentStep: .constant(3)
    )
}
