import SwiftUI

struct StudyHomeView: View {
    
    @StateObject var viewModel = PlayStudyViewModel()
    @State var isPlayStudyActive: Bool = false
    @State private var studyDates: [Date] = [Date()]
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 35)
                
                Text("Choose a deck and study!")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .padding(.bottom,35)
               
                MonthlyCalendarView(studyDates: studyDates)
                    .padding(.horizontal,20)
                    .padding(.bottom,10)
                
                Picker("Choose a deck", selection: $viewModel.selectionDeck) {
                    ForEach(viewModel.decks.indices, id: \.self) { index in
                        Text(viewModel.decks[index].name).tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 200, height: 100)
                .clipped()
                .cornerRadius(8)
                .padding(.bottom,20)
                
                Button {
                    isPlayStudyActive = true
                } label: {
                    Text("Start")
                }
                .font(.system(size: 23, weight: .semibold, design: .rounded))
                .frame(width: 300, height: 60)
                .foregroundStyle(.white)
                .background(.cyan)
                .cornerRadius(10)
                .navigationDestination(isPresented: $isPlayStudyActive) {
                    PlayStudyView(viewModel: PlayStudyViewModel(), selectedDeck: $viewModel.selectionDeck)
                }
                
                Spacer()

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
            .navigationBarBackButtonHidden()
        }
    }
}

struct MonthlyCalendarView: View {
    var studyDates: [Date]
    private let calendar = Calendar.current
    
    // 現在の月の最初の日を取得
    private var startOfMonth: Date {
        let components = calendar.dateComponents([.year, .month], from: Date())
        return calendar.date(from: components)!
    }
    
    // 現在の月の全ての日を取得
    private var daysInMonth: [Date] {
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        return range.compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: startOfMonth) }
    }
    
    // 現在の月名を取得
    private var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: startOfMonth)
    }
    
    var body: some View {
        VStack {
            Text("Monthly Study Tracker")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .padding(.bottom, 10)
            
            Text(monthName)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .padding(.bottom, 10)
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(daysInMonth, id: \.self) { date in
                    let isStudied = studyDates.contains { calendar.isDate($0, inSameDayAs: date) }
                    
                    VStack {
                        Text("\(calendar.component(.day, from: date))")
                            .font(.caption)
                            .padding(8)
                            .background(isStudied ? Color.green : Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(12)
    }
}


#Preview {
    StudyHomeView(viewModel: PlayStudyViewModel())
}
