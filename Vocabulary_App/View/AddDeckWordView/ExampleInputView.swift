import SwiftUI

// TO DO LIST
// 1. Make a button to encapsulate the word in {{}} using UI kit : Priority 2

struct ExampleInputView: View {
    
    @State private var isReviewAndAddActive: Bool = false
    @State private var activeAlert: ActiveAlert? = nil
    @Binding var word : String
    @Binding var definition : String
    @Binding var example: String
    @Binding var translation: String
    @Binding var currentStep: Int
    @FocusState var isFocused: Bool
    
    enum ActiveAlert: Identifiable {
        case emptyFields
        case missingBrackets
        
        var id: Int {
            switch self {
            case .emptyFields:
                return 1
            case .missingBrackets:
                return 2
            }
        }
    }
    
    func checkBracketExists(sentence: String) -> Bool {
        return sentence.contains("{{") && sentence.contains("}}")
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { _ in
                VStack {
                    Spacer().frame(height:10)
                    Text("Add an Example")
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
                                            .font(.system(size: 20, weight: .semibold, design: .rounded))
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
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            TextEditor(text: $example)
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .frame(width: 330, height: 80)
                                .cornerRadius(5)
                                .focused($isFocused)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray, lineWidth: 3)
                                }
                                .overlay(alignment: .topLeading) {
                                    if example.isEmpty {
                                        Text("Example sentence here")
                                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                                            .allowsHitTesting(false)
                                            .foregroundColor(Color(uiColor: .placeholderText))
                                            .padding(.leading, 10)
                                            .padding(.top, 8)
                                    }
                                }
                                .padding(.leading, 10)
                            
                            Spacer().frame(width: 5)
                            
                            Button(action: {
                                example = ""
                            }) {
                                Image(systemName: "delete.left")
                                    .foregroundColor(Color(UIColor.opaqueSeparator))
                            }
                            .padding(.top, 4)
                            .opacity(example.isEmpty ? 0 : 1)
                        }
                    }
                    .padding(.leading,15)
                    
                    Spacer().frame(height: 10)
                    
                    HStack {
                        Button {
                            Task {
                                do {
                                    example = try await WordService.shared.generateSentence(word: word, definition: definition)
                                    print("Response from WordService: \(example)")
                                } catch {
                                    print("Error in generating sentence: \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            Text("Generate an example sentence")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundStyle(.black)
                                .frame(width: 250, height:25)
                                .padding(.vertical,5)
                        }
                        .background(
                            Color.blue
                                .overlay(.black.opacity(0.1))
                        )
                        .cornerRadius(10)
                     
                        Button {
                            Task {
                                do {
                                    example = try await WordService.shared.addBrackets(word: word, example: example)
                                    print("Response from WordService: \(example)")
                                } catch {
                                    print("Error in generating sentence: \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            Text("{ }")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(.black)
                        .frame(width: 30, height: 30)
                        .background(.white)
                        .cornerRadius(7)
                    }
                    .padding(.leading,30)
                    .padding(.top,8)
                    
                    Spacer().frame(height: 20)
                    
                    HStack {
                        TextEditor(text: $translation)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .frame(width: 330, height: 80)
                            .cornerRadius(5)
                            .focused($isFocused)
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 2)
                            }
                            .overlay(alignment: .topLeading) {
                                if translation.isEmpty {
                                    Text("Example translation here")
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .allowsHitTesting(false)
                                        .foregroundColor(Color(uiColor: .placeholderText))
                                        .padding(.leading, 10)
                                        .padding(.top, 8)
                                }
                            }
                            .padding(.leading,10)
                        
                        Button(action: {
                            translation = ""
                        }) {
                            Image(systemName: "delete.left")
                                .foregroundColor(Color(UIColor.opaqueSeparator))
                        }
                        .padding(.top, 4)
                        .opacity(translation.isEmpty ? 0 : 1)
                    }
                    .padding(.leading,15)
                    
                    Spacer().frame(height: 10)
                    
                    Button {
                        if !example.isEmpty {
                            Task {
                                do {
                                    translation = try await WordService.shared.generateTranslation(example: example)
                                } catch {
                                    print("Error in generating sentence: \(error.localizedDescription)")
                                }
                            }
                        } else {
                            print("Please make an example sentence first.")
                        }
                    } label: {
                        Text("Generate a translation")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(.black)
                            .frame(width: 250, height:25)
                            .padding(.vertical,5)
                    }
                    .background(
                        Color.blue
                            .overlay(.black.opacity(0.1))
                    )
                    .cornerRadius(10)
                    .padding(.top,8)
                    
                    Spacer().frame(height: 50)
                    
                    HStack {
                        Button {
                            currentStep = 1
                        } label: {
                            Text("Previous")
                        }
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .frame(width:150, height: 50)
                        .foregroundStyle(.blue)
                        .background(.white)
                        .cornerRadius(10)
                        
                        Spacer().frame(width: 30)
                        
                        Button {
                            if example.isEmpty || translation.isEmpty {
                                activeAlert = .emptyFields
                            } else if !checkBracketExists(sentence: example) {
                                print("Missing brackets in the example")
                                activeAlert = .missingBrackets
                            } else {
                                currentStep = 3
                            }
                        } label: {
                            Text("Next")
                        }
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .frame(width:150, height: 50)
                        .foregroundStyle(example.isEmpty || translation.isEmpty ? .white : .blue)
                        .background(example.isEmpty || translation.isEmpty ? .gray : .white)
                        .cornerRadius(10)
                        .alert(item: $activeAlert) { alert in
                            switch alert {
                            case .emptyFields:
                                return Alert(
                                    title: Text("Error"),
                                    message: Text("Please fill in the first two blanks")
                                )
                            case .missingBrackets:
                                return Alert(
                                    title: Text("Error"),
                                    message: Text("Please include the target word inside the brackets. eg. I {{like}} apples.")
                                )
                            }
                        }
                        .disabled(example.isEmpty || translation.isEmpty)
                    }
                    Spacer()
                }
                .ignoresSafeArea(.keyboard, edges: .all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.blue.gradient)
                .navigationBarBackButtonHidden()
                .onTapGesture {
                    isFocused = false
                }
            }
        }
    }
}

#Preview {
    ExampleInputView(
        word: .constant("Study"), definition: .constant("勉強する"),
        example: .constant("I have been {{studying}} English for about three years."),
        translation: .constant("英語を約三年間勉強しています。"),
        currentStep: .constant(3)
    )
}




