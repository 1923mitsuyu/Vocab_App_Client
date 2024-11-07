import SwiftUI

struct DeckView: View {
    @State private var deckName: String = ""
    var body: some View {
        NavigationStack {
            VStack {
              
                Text("Create a new deck!")
                    .padding(.vertical,30)
                    .fontWeight(.bold)
                    .font(. system(size: 25))
                TextField("Deck name here", text: $deckName)
                    .frame(height: 30)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .padding(.horizontal)
                Spacer().frame(height: 20)
                Button {
                    print("Jump to the next page")
                } label: {
                    Text("Next")
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .frame(maxWidth: 200, minHeight: 40)
                }
                .background(.white)
                .cornerRadius(10)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
        }
    }
}

#Preview {
    DeckView()
}
