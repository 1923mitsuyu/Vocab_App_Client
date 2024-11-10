import SwiftUI

// TO DO LIST
// 1. Users can edit the word and example when the screen is tapped

struct ReviewAndAddView: View {
    
    @Binding var word: String
    @Binding var definition: String
    @Binding var example: String
    @Binding var translation: String
    @Binding var note: String
    @Binding var currentStep: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height:10)
                Text("Review and Add")
                    .fontWeight(.semibold)
                    .font(. system(size: 25))
                    .padding(.bottom,10)
                
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
                .frame(maxWidth: .infinity).padding(.horizontal)
                
                Form {
                    Section(header: Text("Word Details")) {
                        Text(word)
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                        
                        Text(definition)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    }
                    
                    Section(header: Text("Example Sentence")) {
                        Text(example)
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                        
                        Text(translation)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    }
                    
                    Section(header: Text("Note")) {
                        
                        Text(note)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(height: 550)
                
                HStack {
                    Button {
                        currentStep = 2
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
                        print("Add the word and example")
                    } label: {
                        Text("Add")
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                            .frame(width: UIScreen.main.bounds.size.width / 6 * 2,height: UIScreen.main.bounds.size.width / 10 * 1)
                    }
                    .background(.white)
                    .cornerRadius(10)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    ReviewAndAddView(
        word: .constant("Procrastinate"),
        definition: .constant("後回しにする"),
        example: .constant("I tend to procrastinate and start to work on assessments in the last minutes before they are due."),
        translation: .constant("私は後回しにすることが多く、締め切り直前に課題に取り掛かります。"),
        note:.constant("Procrastinator: 後回しにする人"),
        currentStep: .constant(3)
    )
}

