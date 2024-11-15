import SwiftUI

// TO DO LIST
// 1. Users turn to the next page to see more decks (pagination) : Priority 2

struct DeckListView: View {
    
    @StateObject var viewModel = DeckViewModel()
    @State private var isCreateDeckActive = false
    @State private var deckToEdit: UUID?
    @State private var deckToDelete: UUID?
    @State private var newDeckName: String = ""
    @State private var showEditSheet: Bool = false
    @State private var isPickerPresented = false
    @State private var selectedSortOption = "Name"
    @State private var showDeleteAlert : Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("All Decks")
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .padding(.leading)
                      
                    Button(action: {
                        isCreateDeckActive = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .font(.system(size: 25))
                    .foregroundStyle(.white)
                    .padding(.trailing, 10)
                    .navigationDestination(isPresented: $isCreateDeckActive) { CreateDeckView(viewModel: viewModel) }
                    
                    Button(action: {
                        isPickerPresented.toggle()
                    }) {
                        Image(systemName: "list.bullet")
                    }
                    .font(.system(size: 25)) 
                    .foregroundStyle(.white)
                    .padding(.trailing, 30)
                }
                .padding(.bottom, -15)
                .padding(.top, 20)
             
                List($viewModel.decks, editActions: .move) { $deck in
                    NavigationLink(destination: NavigationParentView(deck: deck)) {
                        HStack {
                            Text(deck.name)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .padding(.vertical, 4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .swipeActions {
                            Button(role: .destructive, action: {
                                deckToDelete = deck.id
                                showDeleteAlert = true
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button(action: {
                                deckToEdit = deck.id
                                newDeckName = deck.name
                                showEditSheet = true
                            }) {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                    }
                }
                .cornerRadius(10)
                .onAppear {
                    print("Decks on DeckListView appear: \(viewModel.decks.map { $0.name })")
                    viewModel.decks.sort { $0.listOrder < $1.listOrder }
                }
                .onChange(of: viewModel.decks) { oldValue, newValue in
                    print("The deck list changed!")
                    var counter = 0
                    for index in viewModel.decks.indices {
                        viewModel.decks[index].listOrder = counter
                        print("Deck Name: \(viewModel.decks[index].name), List Order: \(viewModel.decks[index].listOrder)")
                        counter += 1
                    }
                    print("--------------------------------")
                }
                .scrollContentBackground(.hidden)
                .actionSheet(isPresented: $isPickerPresented) {
                    ActionSheet(
                        title: Text("Select Sorting Option"),
                        buttons: [
                            .default(Text("By Name(Ascending)")) {
                                selectedSortOption = "Name"
                                viewModel.decks.sort { $0.name < $1.name }
                            },
                            .default(Text("By Name (Descending)")) {
                                selectedSortOption = "Name"
                                viewModel.decks.sort { $0.name > $1.name }
                            },
                            .default(Text("By Date Added")) {
                                selectedSortOption = "Date Added"
                                viewModel.decks.sort { $0.listOrder < $1.listOrder }
                            },
                            .cancel()
                        ]
                    )
                }
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("Delete Deck"),
                        message: Text("Are you sure you want to delete this deck?"),
                        primaryButton: .destructive(Text("Delete")) {
                            
                            // Logics to remove the deck from db
                            if let deckToDelete = deckToDelete {
                                if let index = viewModel.decks.firstIndex(where: { $0.id == deckToDelete }) {
                                    viewModel.decks.remove(at: index)
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .sheet(isPresented: $showEditSheet) {
                    VStack {
                        Spacer().frame(height:20)
                        Text("Edit the Deck Name")
                            .font(.system(size: 25, weight: .semibold, design: .rounded))
                            .padding(.top, 25)
                            .padding(.bottom,20)
                        
                        TextField("", text: $newDeckName)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                            .padding(.horizontal)
                        
                        Spacer().frame(height:25)
                        Button {
                            
                            // Logics to edit the deck on db
                            guard let deckToEdit = deckToEdit else {
                                print("Error: deckToEdit is nil")
                                return
                            }
                            // 編集するデッキのインデックスを取得
                            if let index = viewModel.decks.firstIndex(where: { $0.id == deckToEdit }) {
                                // 編集した名前でデッキ名を更新
                                viewModel.decks[index].name = newDeckName
                                
                                print("DeckToEdit: \(String(describing: deckToEdit))")
                                print("New Name: \(viewModel.decks[index].name)")
                            } else {
                                print("Error: Deck not found")
                            }
                            
                            showEditSheet = false
                        } label: {
                            Text("Save")
                        }
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding()
                        .background(.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scrollContentBackground(.hidden)
                    .padding(.bottom, 30)
                    .background(.blue.opacity(0.5))
                }
            }
            .background(.blue.gradient)
            .onAppear {
                // Logics here to fetch all decks and words info
                Task {
                    do {
                        let decks = try await DeckService.shared.getDecks()
                    } catch {
                        print("Error in fetching all decks: \(error.localizedDescription)")
                    }
                }
               
            }
        }
    }
}

struct CreateDeckView_Previews: PreviewProvider {
    @State static var decks: [Deck] = [
           Deck(name: "Sample Deck1", words: [
            Word(word: "Procrastinate", definition: "後回しにする", example: "I procrastinated my assignments, but I finished them in time.", translation: "私は課題を後回しにした。", wordOrder: 0, deckId: 1),
            Word(word: "Ubiquitous", definition: "どこにでもある", example: "Smartphones are ubiquitous nowadays.", translation: "スマホは至る所にある", wordOrder: 1, deckId: 1)], listOrder: 6, userId: 1),
           
           Deck(name: "Sample Deck2", words: [
            Word(word: "Serenity", definition: "静けさ", example: "The lake was a place of serenity.", translation: "湖は静けさのある場所だった。", wordOrder: 0, deckId: 1),
            Word(word: "Ephemeral", definition: "儚い", example: "Life is ephemeral.", translation: "人生は儚いものだ。", wordOrder: 1, deckId: 1)], listOrder: 1, userId: 1),
           
           Deck(name: "Sample Deck3", words: [
            Word(word: "Serenity", definition: "静けさ", example: "The lake was a place of serenity.", translation: "湖は静けさのある場所だった。", wordOrder: 0, deckId: 1),
            Word(word: "Ephemeral", definition: "儚い", example: "Life is ephemeral.", translation: "人生は儚いものだ。", wordOrder: 1, deckId: 1)], listOrder: 2, userId: 1),
           
           Deck(name: "Sample Deck4", words: [
            Word(word: "Serenity", definition: "静けさ", example: "The lake was a place of serenity.", translation: "湖は静けさのある場所だった。", wordOrder: 0, deckId: 1),
            Word(word: "Ephemeral", definition: "儚い", example: "Life is ephemeral.", translation: "人生は儚いものだ。", wordOrder: 1, deckId: 1)], listOrder: 3, userId: 1),
           
           Deck(name: "Sample Deck5", words: [
            Word(word: "Serenity", definition: "静けさ", example: "The lake was a place of serenity.", translation: "湖は静けさのある場所だった。", wordOrder: 0, deckId: 1),
            Word(word: "Ephemeral", definition: "儚い", example: "Life is ephemeral.", translation: "人生は儚いものだ。", wordOrder: 1, deckId: 1)], listOrder: 4, userId: 1),
           
           Deck(name: "Sample Deck6", words: [
            Word(word: "Serenity", definition: "静けさ", example: "The lake was a place of serenity.", translation: "湖は静けさのある場所だった。", wordOrder: 0, deckId: 1),
            Word(word: "Ephemeral", definition: "儚い", example: "Life is ephemeral.", translation: "人生は儚いものだ。", wordOrder: 1, deckId: 1)], listOrder: 5, userId: 1),
       ]
    
    static var previews: some View {
        DeckListView(viewModel: DeckViewModel())
    }
}
