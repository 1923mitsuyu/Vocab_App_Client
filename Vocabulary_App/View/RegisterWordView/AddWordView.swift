import SwiftUI

// TO DO LIST for this view
// 1. Check if the first two values are not empty
// 2. Include a placeholder in the text editors
// 3. Break this into two views (word and example)
// 4. Make a progress bar at the top (1st step~)
// 5. Make a button to generate example with AI
// 6. Create a tab at the buttom

struct AddWordView: View {
    
    @State private var newWord: String = ""
    @State private var newWordTranslation: String = ""
    @State private var example: String = ""
    @State private var exampleTranslation: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Let's add a new word!")
                    .fontWeight(.semibold)
                    .font(. system(size: 25))
                    .padding(.bottom,10)
                TextField("New Word", text: $newWord)
                    .modifier(TextFieldModifier(height: 30))
                Spacer().frame(height: 20)
                TextField("Translation here", text: $newWordTranslation)
                    .modifier(TextFieldModifier(height: 30))
                Spacer().frame(height: 20)
                TextEditor(text: $example)
                    .frame(width: 370, height: 80)
                    .cornerRadius(5)
                Spacer().frame(height: 20)
                TextEditor(text: $exampleTranslation)
                    .frame(width: 370, height: 80)
                    .cornerRadius(5)
                Spacer().frame(height: 20)
                TextEditor(text: $exampleTranslation)
                    .frame(width: 370, height: 150)
                    .cornerRadius(5)
                Spacer().frame(height: 40)
                Button {
                    print("Button tapped")
                } label: {
                     Text("Add")
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.size.width / 6 * 2,height: UIScreen.main.bounds.size.width / 10 * 1)
                }
                .background(.white)
                .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
        }
    }
}

struct TextFieldModifier: ViewModifier {
    
    var height: CGFloat
    
    func body(content: Content) -> some View {
        content
        .frame(height: height)
        .padding()
        .background(Color.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 2)
        )
        .padding(.horizontal)

    }
}

#Preview {
    AddWordView()
}
