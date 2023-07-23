//
//  StatisticsView.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI

class DateViewModel: ObservableObject {
    @Published var selectedYear = Calendar.current.component(.year, from: Date()){
        didSet {
            updateStartOfWeek()
        }
    }
    @Published var selectedMonth = Calendar.current.component(.month, from: Date()){
        didSet {
            updateStartOfWeek()
        }
    }
    
    @Published var startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    
    var selectedDate: Date {
        Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1))!
    }

    var weekButtonText: Text {
        let formattedStartDate = Utilities.formatYearMonthDay(startOfWeek)
        let formattedEndDate = Utilities.formatYearMonthDay(Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!)
        
        return Text("\(formattedStartDate) - \(formattedEndDate)")
    }

    private func updateStartOfWeek() {
        let calendar = Calendar.current
        startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
    }
        
    
    var yearMonthButtonText: Text {
        Text("\(Utilities.formatNum(selectedYear))년 \(selectedMonth)월")
    }
    
    var yearButtonText: Text {
        Text("\(Utilities.formatNum(selectedYear))년")
    }
}

struct StatisticsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DateViewModel()

    @State private var workPoint = 2
    @State private var healthPoint = 3
    @State private var familyPoint = 4
    @State private var relationshipPoint = 4
    @State private var assetPoint = 1
    
    @State private var workNote = "일"
    @State private var healthNote = "건강"
    @State private var familyNote = "가족"
    @State private var relationshipNote = "관계"
    @State private var assetNote = "자산"
    
    @State private var barWidth = 60
    @State private var barHeight = 200
    
    @State private var selectedOption = 1
    @State private var isShowPopup = false
    
    var totalPoint: Int {
        workPoint + healthPoint + familyPoint + relationshipPoint + assetPoint
    }

    var maxPoint: Int {
        max(workPoint, healthPoint, familyPoint, relationshipPoint, assetPoint)
    }
    
    var noteArray: [(Int, String)] {
        [
            (workPoint, workNote),
            (healthPoint, healthNote),
            (familyPoint, familyNote),
            (relationshipPoint, relationshipNote),
            (assetPoint, assetNote)
        ]
    }
    
    var body: some View {
            ZStack{
                Color("Background").ignoresSafeArea(.all)
                ScrollView {
                    Spacer()
                    VStack {
                        Text("통계 분석").font(.system(size: 28)).bold()
                            .padding(15)
                    }
                    VStack {
                        
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color("LightGray2"))
                            .frame(width: 300, height: 50)
                            .overlay(
                                HStack{
                                    DateOptionView(text: "주간", num: 1, selectedOption: $selectedOption)
                                    DateOptionView(text: "월간", num: 2, selectedOption: $selectedOption)
                                    DateOptionView(text: "연간", num: 3, selectedOption: $selectedOption)
                                }
                            )
                            .padding(.bottom, 20)
                    }
                    VStack{
                        HStack{
                            switch selectedOption {
                            case 1:
                                Button(action: {
                                    viewModel.startOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: viewModel.startOfWeek)!
                                }) {
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                    .frame(maxWidth: 40)
                                viewModel.weekButtonText
                                    .foregroundColor(.black)
                                Spacer()
                                    .frame(maxWidth: 40)
                                Button(action: {
                                    viewModel.startOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: viewModel.startOfWeek)!
                                }) {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.gray)
                                }
                                .disabled(viewModel.startOfWeek == Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!)
                            case 2:
                                Button(action: {
                                    viewModel.selectedMonth -= 1
                                        if viewModel.selectedMonth < 1 {
                                            viewModel.selectedMonth = 12
                                            viewModel.selectedYear -= 1
                                        }
                                }) {
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                    .frame(maxWidth: 40)
                                Button(action: {
                                    isShowPopup = true
                                }) {
                                    viewModel.yearMonthButtonText
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                    .frame(maxWidth: 40)
                                Button(action: {
                                    viewModel.selectedMonth += 1
                                        if viewModel.selectedMonth > 12 {
                                            viewModel.selectedMonth = 1
                                            viewModel.selectedYear += 1
                                        }
                                }) {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.gray)
                                }
                                .disabled(viewModel.selectedYear == Calendar.current.component(.year, from: Date()) && viewModel.selectedMonth == Calendar.current.component(.month, from: Date()))
                            case 3:
                                Button(action: {
                                    viewModel.selectedYear -= 1
                                }) {
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                    .frame(maxWidth: 40)
                                Button(action: {
                                    isShowPopup = true
                                }) {
                                    viewModel.yearButtonText
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                    .frame(maxWidth: 40)
                                Button(action: {
                                    viewModel.selectedYear += 1
                                }) {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.gray)
                                }
                                .disabled(viewModel.selectedYear == Calendar.current.component(.year, from: Date()))
                            default:
                                Text("")
                            }
                            
                            
                        }
                    }
                    
                    VStack {
                        HStack(spacing: 0) {
                            StatisticsCellView(barWidth: CGFloat(barWidth), barHeight: CGFloat(barHeight), note: workNote, point: workPoint, maxPoint: maxPoint, totalPoint: totalPoint)
                            StatisticsCellView(barWidth: CGFloat(barWidth), barHeight: CGFloat(barHeight), note: healthNote, point: healthPoint, maxPoint: maxPoint, totalPoint: totalPoint)
                            StatisticsCellView(barWidth: CGFloat(barWidth), barHeight: CGFloat(barHeight), note: familyNote, point: familyPoint, maxPoint: maxPoint, totalPoint: totalPoint)
                            StatisticsCellView(barWidth: CGFloat(barWidth), barHeight: CGFloat(barHeight), note: relationshipNote, point: relationshipPoint, maxPoint: maxPoint, totalPoint: totalPoint)
                            StatisticsCellView(barWidth: CGFloat(barWidth), barHeight: CGFloat(barHeight), note: assetNote, point: assetPoint, maxPoint: maxPoint, totalPoint: totalPoint)
                        }
                        Divider()
                            .background(Color.gray)
                            .frame(width: 330)
                            .padding(.top, 40)
                    }
                    .padding(20)
                    VStack {
                        let maxNote = noteArray.first { $0.0 == maxPoint }?.1 ?? "error"
                        
                        HStack(spacing: 0) {
                            Group {
                                switch selectedOption {
                                case 1:
                                    Text("이번 주는 ")
                                        .font(.system(size: 26))
                                        .multilineTextAlignment(.center)
                                case 2:
                                    Text("이번 달은 ")
                                        .font(.system(size: 26))
                                        .multilineTextAlignment(.center)
                                case 3:
                                    Text("올해는 ")
                                        .font(.system(size: 26))
                                        .multilineTextAlignment(.center)
                                default:
                                    Text("")
                                }
                            }
                            Text(maxNote)
                                .bold()
                                .font(.system(size: 26))
                                .multilineTextAlignment(.center)
                            Text("에")
                                .font(.system(size: 26))
                                .multilineTextAlignment(.center)
                        }
                        VStack{
                            Text("주로 집중하셨군요!")
                                .font(.system(size: 26))
                                .multilineTextAlignment(.center)
                        }
                    }
                    VStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(width: 330, height: 200)
                            .overlay(
                                Text(".")
                            )
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
            .sheet(isPresented: $isShowPopup) {
                YearMonthPickerPopup(viewModel: viewModel, isShowPopup: $isShowPopup, selectedOption: $selectedOption)
                    .frame(width: 300, height: 400)
                    .background(BackgroundClearView())
                    .ignoresSafeArea()
            }
    }
}

// MARK: - DateOptionView
struct DateOptionView: View {
    var text: String
    var num: Int
    @Binding var selectedOption: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(selectedOption == num ? Color("DarkGray") : Color("LightGray2"))
            .frame(width: 90, height: 35)
            .overlay(
                Text(text)
                    .foregroundColor(selectedOption == num ? Color.white : Color.black)
            )
            .onTapGesture {
                selectedOption = num
            }
    }
}

// MARK: - BackgroundClearView
struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}

// MARK: - YearMonthPickerPopup
struct YearMonthPickerPopup: View {
    @ObservedObject var viewModel: DateViewModel
    @Binding var isShowPopup: Bool
    @Binding var selectedOption: Int
    
    @State private var oldSelectedYear: Int
    @State private var oldSelectedMonth: Int
        
    init(viewModel: DateViewModel, isShowPopup: Binding<Bool>, selectedOption: Binding<Int>) {
        self.viewModel = viewModel
        _isShowPopup = isShowPopup
        _selectedOption = selectedOption
        _oldSelectedYear = State(initialValue: viewModel.selectedYear)
        _oldSelectedMonth = State(initialValue: viewModel.selectedMonth)
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                HStack {
                    YearPicker(viewModel: viewModel)
                    if selectedOption == 2{
                        MonthPicker(viewModel: viewModel)
                    }
                }
                .padding()
                HStack{
                    Button(action: {
                        viewModel.selectedYear = oldSelectedYear
                        viewModel.selectedMonth = oldSelectedMonth
                        isShowPopup = false
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
            }
            .padding()
            .frame(width: 300, height: 400)
            .background(Color.white)
            .cornerRadius(30)
            
        }
        .background(
            Color.clear
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        self.isShowPopup.toggle()
                    }
                }
        )
    }
}

// MARK: - YearPicker
struct YearPicker: View {
    @ObservedObject var viewModel: DateViewModel
    
    let currentYear: Int = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        Picker("년도 선택", selection: $viewModel.selectedYear){
            ForEach(2017...currentYear, id: \.self) { year in
                Text("\(Utilities.formatNum(year))년")
            }
        }
        .pickerStyle(WheelPickerStyle())
    }
}

// MARK: - MonthPicker
struct MonthPicker: View {
    @ObservedObject var viewModel: DateViewModel
    
    var body: some View {
        Picker("월 선택", selection: $viewModel.selectedMonth) {
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

// MARK: - StatisticsCellView
struct StatisticsCellView: View {
    let barWidth: CGFloat
    let barHeight: CGFloat
    
    let note: String
    let point: Int
    let maxPoint: Int
    let totalPoint: Int
    
    var body: some View {
        let heightRatio: CGFloat = CGFloat(point) / CGFloat(totalPoint)
        
        VStack(spacing: 110) {
            Spacer()
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("LightGray2"))
                    .frame(width: barWidth, height: barHeight)
                    .overlay(
                        Rectangle()
                            .fill(point == maxPoint ? Color("DarkQ") : Color("LightGray"))
                            .frame(width: barWidth, height: heightRatio * barHeight)
                            .offset(y: (1 - heightRatio) * barHeight / 2)
                    )
                    .clipped()
                    .mask(RoundedRectangle(cornerRadius: 10))
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            VStack {
                Text(note).font(.system(size: 15))
                Text("\(Int(heightRatio * 100))%").font(.system(size: 13)) //소수점 버려지는거 어떻게 할지?
            }
        }
    }
}


// MARK: - Utilities
struct Utilities {
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

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
