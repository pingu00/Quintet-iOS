
//  RecordView.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.

import SwiftUI

enum recordElement {
    case work, health, relation, family, money, None
}

struct RecordView: View {
    @Environment(\.dismiss) private var dismiss
    @State var currentDate: Date = Date()
    @State private var selectedDate = Date()
    @StateObject private var viewModel = DateViewModel()
    @StateObject private var coreDataViewModel = CoreDataViewModel()
    @State private var isShowingBtn = false
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
   
    
    var body: some View {
            ZStack {
                Color("Background")
                    .ignoresSafeArea(.all)
                ScrollView {
                    VStack(spacing: 35) {
                        VStack {
                            HStack {
                                Spacer()
                                Text("기록 확인하기")
                                    .font(.system(size: 28))
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            VStack {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 300, height: 40)
                                        .cornerRadius(25)
                                        .foregroundColor(Color("LightGray2"))
                                    
                                    Rectangle()
                                        .frame(width: 155, height: 30)
                                        .cornerRadius(25)
                                        .foregroundColor(Color("DarkGray"))
                                        .offset(x: isShowingBtn ? 68 : -68, y: 0)
                                    
                                    HStack(spacing: 95) {
                                        Button(action: {
                                            isShowingBtn = false
                                        }) {
                                            Text("날짜별")
                                                .fontWeight(.semibold)
                                                .foregroundColor(isShowingBtn ? .black : .white)
                                        }
                                        
                                        Button(action: {
                                            isShowingBtn = true
                                        }) {
                                            Text("요소별")
                                                .fontWeight(.semibold)
                                                .foregroundColor(isShowingBtn ? .white : .black)
                                        }
                                    }
                                }
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.horizontal, 30)
                            }
                            
                            
                        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .padding(.top, 50)
                        
                        //요소별
                        if (isShowingBtn == true) {
                                RecordElementView(recordIndex: .None)
                                    .padding(.bottom, 40)
                        }
                        
                        //날짜별
                        else {
                            CalendarView(selectedYear: $viewModel.selectedYear, selectedMonth: $viewModel.selectedMonth, currentDate: $currentDate)
                                .padding(.horizontal, 20)
                        }
                    }
                }
            
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button (action:
                                {dismiss()}){
                        Image(systemName: "chevron.backward")
                            .bold()
                            .foregroundColor(Color(.black))
                    }
                }
            }
            .onAppear {
                viewModel.updateCalendar()
            }
            .onChange(of: viewModel.selectedYear) { _ in
                viewModel.updateCalendar()
            }
            .onChange(of: viewModel.selectedMonth) { _ in
                viewModel.updateCalendar()
            }
        }
}


struct YearPicker_: View {
    @StateObject var viewModel: DateViewModel
    @Binding var selectedYear: Int

    let currentYear: Int = Calendar.current.component(.year, from: Date())

    var body: some View {
        Picker("년도 선택", selection: $selectedYear){
            ForEach(2017...currentYear, id: \.self) { year in
                Text("\(Utilities_.formatNum(year))년")
            }
        }
        .pickerStyle(WheelPickerStyle())
    }
}


struct recordCard: View {
    var icon: String
    var title: String
    var subtitle: String

    var body: some View {
        HStack(spacing: 30) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color("DarkGray"))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.medium)
                    .font(.system(size: 20))
                    .foregroundColor(.black)

                if !subtitle.isEmpty {
                        Text(subtitle)
                            .fontWeight(.regular)
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                            .lineLimit(nil)
                }
            }
            .frame(minHeight: 55)
            Spacer()
        }
        .frame(width: 320)
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct RecordElementView : View {
    @State var recordIndex: recordElement
    @State private var isShowPopup = false
    @StateObject private var viewModel = DateViewModel()
    @ObservedObject private var coreDataViewModel = CoreDataViewModel()
    var healthRecords: [RecordMetaData] {
        return coreDataViewModel.getHealthRecords(for: viewModel.selectedYear, month: viewModel.selectedMonth)
    }
    var workRecords: [RecordMetaData] {
        return coreDataViewModel.getWorkRecords(for: viewModel.selectedYear, month: viewModel.selectedMonth)
    }
    var relationshipRecords: [RecordMetaData] {
        return coreDataViewModel.getRelationshipRecords(for: viewModel.selectedYear, month: viewModel.selectedMonth)
    }
    var assetRecords: [RecordMetaData] {
        return coreDataViewModel.getAssetRecords(for: viewModel.selectedYear, month: viewModel.selectedMonth)
    }
    var familyRecords: [RecordMetaData] {
        return coreDataViewModel.getFamilyRecords(for: viewModel.selectedYear, month: viewModel.selectedMonth)
    }
    
    func displayRecords(for recordElement: recordElement, records: [RecordMetaData]) -> some View {
        VStack {
            Divider()
                .padding(.horizontal)
            Button(action: {
                isShowPopup = true
            }) {
                HStack {
                    viewModel.yearMonthButtonTextRecordVer
                        .foregroundColor(Color.black)
                    Image(systemName: isShowPopup ? "chevron.compact.up" : "chevron.compact.down")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                }
                .padding(.top, 10)
                .padding(.trailing, 180)
            }
            .sheet(isPresented: $isShowPopup) {
                YearMonthPickerPopup_(viewModel: viewModel, isShowPopup: $isShowPopup)
                    .frame(width: 300, height: 400)
                    .background(BackgroundClearView_())
                    .ignoresSafeArea()
            }
            ForEach(records) { metaData in
                ForEach(metaData.records) { record in
                    recordCard(icon: record.icon, title: record.title, subtitle: record.subtitle)
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                Button(action: {
                    self.recordIndex = .work
                }) {
                    ElementCard(icon: "pencil", title: "일", size: 34, space: 55, fC: recordIndex == .work ? Color.white : Color("DarkGray"), bC: recordIndex == .work ? Color("DarkQ") : Color.white)
                }
                
                Button(action: {
                    self.recordIndex = .health
                }) {
                    ElementCard(icon: "cross.circle.fill", title: "건강", size: 30, space: 30, fC: recordIndex == .health ? Color.white : Color("DarkGray"), bC: recordIndex == .health ? Color("DarkQ") : Color.white)
                }
            }
            
            HStack(spacing: 6) {
                Button(action: {
                    self.recordIndex = .relation
                }) {
                    ElementCard(icon: "person.3.fill", title: "관계", size: 25, space: 25, fC: recordIndex == .relation ? Color.white : Color("DarkGray"), bC: recordIndex == .relation ? Color("DarkQ") : Color.white)
                }
                
                Button(action: {
                    self.recordIndex = .family
                }) {
                    ElementCard(icon: "heart.fill", title: "가족", size: 30, space: 30, fC: recordIndex == .family ? Color.white : Color("DarkGray"), bC: recordIndex == .family ? Color("DarkQ") : Color.white)
                }
            }
            
            HStack(spacing: 230) {
                Button(action: {
                    self.recordIndex = .money
                }) {
                    Text("자산")
                        .fontWeight(.bold)
                        .font(.system(size: 23))
                        .foregroundColor(recordIndex == .money ? Color.white : Color("DarkGray"))
                        .offset(x: -113)
                    
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(recordIndex == .money ? Color.white : Color("DarkGray"))
                        .offset(x: 106)
                }
            }
            .frame(width: 330, height: 50)
            .padding(20)
            .background(recordIndex == .money ? Color("DarkQ") : Color.white)
            .cornerRadius(20)
        }

            switch recordIndex {
            case .health:
                displayRecords(for: recordIndex, records: healthRecords)
            case .work:
                displayRecords(for: recordIndex, records: workRecords)
            case .money:
                displayRecords(for: recordIndex, records: assetRecords)
            case .relation:
                displayRecords(for: recordIndex, records: relationshipRecords)
            case .family:
                displayRecords(for: recordIndex, records: familyRecords)
            case .None:
                EmptyView()
            }
        
    }
}

    struct ElementCard : View {
        var icon : String
        var title : String
        var size : Int
        var space : Int
        var fC : Color
        var bC : Color
        
        var body: some View {
            
            HStack(spacing: CGFloat(space)) {
                
                Text(title)
                    .fontWeight(.bold)
                    .font(.system(size: 23))
                    .foregroundColor(fC)
                Image(systemName: icon)
                    .font(.system(size: CGFloat(size)))
                    .foregroundColor(fC)
                    .fontWeight(.bold)
                
            }
            .frame(width: 140, height: 50)
            .padding(20)
            .background(bC)
            .cornerRadius(20)
            
        }
    }
    
    struct BackgroundClearView_: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            let view = UIView()
            DispatchQueue.main.async {
                view.superview?.superview?.backgroundColor = .clear
            }
            return view
        }
        func updateUIView(_ uiView: UIView, context: Context) {}
    }
    
    struct Utilities_{
        static func formatNum(_ num: Int) -> String {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .none
            
            return numberFormatter.string(from: NSNumber(value: num)) ?? ""
        }
        
        static func formatYearMonthDay(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            return formatter.string(from: date)
        }
        static func formatMonthDay(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM.dd"
            return formatter.string(from: date)
        }
        
    }

    
struct CalendarView: View {
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int
    @Binding var currentDate: Date
    @StateObject private var viewModel = DateViewModel()
    @StateObject private var coreDataViewModel = CoreDataViewModel()
    @State private var selectedDate = Date()
    @State private var isShowPopup = false
    @State var currentMonth: Int = 0
    let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        
        VStack(spacing: 13) {
            
            HStack(spacing: -7){
                
                Button(action: {
                    isShowPopup = true
                }) {
                    viewModel.yearMonthButtonTextRecordVer
                        .padding(.horizontal)
                        .foregroundColor(Color.black)
                    
                }.sheet(isPresented: $isShowPopup) {
                    YearMonthPickerPopup_(viewModel: viewModel, isShowPopup: $isShowPopup)
                        .frame(width: 300, height: 400)
                        .background(BackgroundClearView_())
                        .ignoresSafeArea()
                }
                
                Image(systemName: isShowPopup ? "chevron.compact.up" : "chevron.compact.down")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
            }
            .padding(.bottom, 17)
            
            HStack(spacing: 4) {
                
                ForEach(days, id: \.self) { day in
                    
                    Text(day)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                    
                }
            }
            
            Divider()
                .padding(.horizontal)
            
            let columns = Array(repeating: GridItem(.fixed(43)), count: 7)
            LazyVGrid(columns: columns, spacing: 7) {
                ForEach(extractDate()) { value in
                    if value.day != -1 {
                        CardView(value: value)
                            .background (
                                Circle()
                                    .frame(width: 43, height: 43)
                                    .foregroundColor(Color("DarkQ"))
                                    .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                            )
                            .onTapGesture {
                                currentDate = value.date
                            }
                    } else {
                        Color.clear
                    }
                }
            }
            .fontWeight(.light)
        }
    
            if let task = coreDataViewModel.getRecordMetaData(selectedYear: selectedYear, selectedMonth: selectedMonth).first (where: { task in
                return isSameDay(date1: task.date, date2: currentDate)
            }) {
                VStack {
                    Text("오늘의 5요소")
                        .font(.system(size: 23))
                        .fontWeight(.semibold)
                        .padding(.trailing, 190)
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                        .foregroundColor(Color.black)
                    
                    ForEach(task.records) { record in
                        recordCard(icon: record.icon, title: record.title, subtitle: record.subtitle)
                    }
                }
                .onChange(of: currentMonth) { newValue in
                    //updating Month
                    currentDate = getCurrentMonth()
                }
            }
    }
        
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        ZStack {
            if value.day != -1 {
                if let task = coreDataViewModel.getRecordMetaData(selectedYear: selectedYear, selectedMonth: selectedMonth).first (where: { task in
                    return isSameDay(date1: task.date, date2: value.date)
                }) {
                    Circle()
                        .fill(isSameDay(date1: task.date, date2: currentDate) ? .white : Color("LightGray2") )
                        .frame(width: 43, height: 43)
                        .opacity(isSameDay(date1: task.date, date2: currentDate) ? 0 : 1)
                        .padding(.vertical, -5)
                        .onTapGesture {
                            currentDate = value.date
                        }

                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: task.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                } else {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date , date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)

                    Spacer()
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        viewModel.getDatesForSelectedMonth()
    }

}

struct MonthPicker_: View {
    @Binding var selectedMonth: Int
    @ObservedObject var viewModel: DateViewModel

    var body: some View {
        Picker("월 선택", selection: $selectedMonth) {
            ForEach(1...getMaxMonth(), id: \.self) { month in
                Text("\(month)월")
            }

        }
        .pickerStyle(WheelPickerStyle())
    }

    private func getMaxMonth() -> Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        if viewModel.selectedYear == currentYear {
            if viewModel.selectedMonth > currentMonth {
                viewModel.selectedMonth = currentMonth
            }
            return currentMonth
        }
        else {
            return 12
        }
    }
}

struct YearMonthPickerPopup_: View {
    @ObservedObject var viewModel: DateViewModel
    @Binding var isShowPopup: Bool
    
    init(viewModel: DateViewModel, isShowPopup: Binding<Bool>) {
        self.viewModel = viewModel
        _isShowPopup = isShowPopup
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                HStack(spacing: -7) {
                    YearPicker_(viewModel: viewModel, selectedYear: $viewModel.selectedYear)
                    MonthPicker_(selectedMonth: $viewModel.selectedMonth, viewModel: viewModel)
                }
            }
            .padding(.top, 60)
            HStack(spacing: 10){
                Button(action: {
                    isShowPopup = false
                    viewModel.updateCalendar()
                }) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Background"))
                        .frame(width: 100, height: 40)
                        .overlay(
                            Text("취소")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                        )
                }
                Button(action: {
                    isShowPopup = false
                    viewModel.selectedYear = viewModel.selectedYear
                    viewModel.selectedMonth = viewModel.selectedMonth
                    viewModel.updateCalendar()
                }) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("DarkQ"))
                        .frame(width: 100, height: 40)
                        .overlay(
                            Text("확인")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        )
                    
                }
            }
            .padding(.top, 300)
            .padding(.horizontal, 30)
            
        }
        .padding()
        .frame(width: 300, height: 400)
        .background(Color.white)
        .cornerRadius(30)
        
    }
 }

extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}


