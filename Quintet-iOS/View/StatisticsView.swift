//
//  StatisticsView.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI

struct StatisticsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var dateViewModel = DateViewModel()
    
    //강한결합
    @StateObject private var statisticsCellViewModel = StatisticsCellViewModel(coreDataViewModel: CoreDataViewModel())
    
    @State private var selectedOption = 1
    @State private var isShowPopup = false
    
    
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
                            // MARK: - 주간
                        case 1:
                            ArrowButton(action: {
                                dateViewModel.startOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: dateViewModel.startOfWeek)!
                            }, imageName: "chevron.backward", isDisabled: dateViewModel.startOfWeek == Calendar.current.date(from: DateComponents(weekOfYear: 1, yearForWeekOfYear: 2017)))
                            
                            Spacer()
                                .frame(maxWidth: 40)
                            
                            dateViewModel.weekButtonText
                                .foregroundColor(.black)
                            
                            Spacer()
                                .frame(maxWidth: 40)
                            
                            ArrowButton(action: {
                                dateViewModel.startOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: dateViewModel.startOfWeek)!
                            }, imageName: "chevron.forward", isDisabled: dateViewModel.startOfWeek == Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!)
                            
                            // MARK: - 월간
                        case 2:
                            ArrowButton(action: {
                                dateViewModel.selectedMonth -= 1
                                if dateViewModel.selectedMonth < 1 {
                                    dateViewModel.selectedMonth = 12
                                    dateViewModel.selectedYear -= 1
                                }
                            }, imageName: "chevron.backward", isDisabled: dateViewModel.selectedYear == 2017 && dateViewModel.selectedMonth == 1)
                            
                            
                            Spacer()
                                .frame(maxWidth: 40)
                            
                            Button(action: {
                                isShowPopup = true
                            }) {
                                dateViewModel.yearMonthButtonText
                                    .foregroundColor(.black)
                            }
                            Spacer()
                                .frame(maxWidth: 40)
                            
                            ArrowButton(action: {
                                dateViewModel.selectedMonth += 1
                                if dateViewModel.selectedMonth > 12 {
                                    dateViewModel.selectedMonth = 1
                                    dateViewModel.selectedYear += 1
                                }
                            }, imageName: "chevron.forward", isDisabled: dateViewModel.selectedYear == Calendar.current.component(.year, from: Date()) && dateViewModel.selectedMonth == Calendar.current.component(.month, from: Date()))
                            
                            // MARK: - 연간
                        case 3:
                            ArrowButton(action: {
                                dateViewModel.selectedYear -= 1
                            }, imageName: "chevron.backward", isDisabled: dateViewModel.selectedYear == 2017)
                            
                            Spacer()
                                .frame(maxWidth: 40)
                            
                            Button(action: {
                                isShowPopup = true
                            }) {
                                dateViewModel.yearButtonText
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                                .frame(maxWidth: 40)
                            
                            ArrowButton(action: {
                                dateViewModel.selectedYear += 1
                            }, imageName: "chevron.forward", isDisabled: dateViewModel.selectedYear == Calendar.current.component(.year, from: Date()))
                        default:
                            Text("")
                        }
                    }
                }
                .onChange(of: selectedOption) { newValue in
                    if newValue == 1 {
                        statisticsCellViewModel.updateWeekValuesFromCoreData()
                    }
                    else if newValue == 2{
                        statisticsCellViewModel.updateMonthValuesFromCoreData()
                    }
                    else {
                        statisticsCellViewModel.updateYearValuesFromCoreData()
                    }
                }
                
                VStack {
                    HStack(spacing: 0) {
                        ForEach(statisticsCellViewModel.noteArray, id: \.1) { (point, note) in
                            StatisticsCellView(selectedOption: $selectedOption, note: note, point: point, maxPoint: statisticsCellViewModel.maxPoint, totalPoint: statisticsCellViewModel.totalPoint)
                        }
                    }
                    Divider()
                        .background(Color.gray)
                        .frame(width: 330)
                        .padding(.top, 40)
                }
                .padding(20)
                VStack {
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
                        Text(statisticsCellViewModel.maxNoteArray.joined(separator: ", "))
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
            YearMonthPickerPopup(viewModel: dateViewModel, isShowPopup: $isShowPopup, selectedOption: $selectedOption)
                .frame(width: 300, height: 400)
                .background(BackgroundClearView())
                .ignoresSafeArea()
        }
    }
}

// MARK: - ArrowButton
struct ArrowButton: View {
    var action: () -> Void
    var imageName: String
    var isDisabled: Bool
    
    var body: some View {
        Button(action: {
            withAnimation{
                action()
            }
        }) {
            
            Image(systemName: imageName)
                .foregroundColor(.gray)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0 : 1)
    }
}

// MARK: - DateOptionView
// 애니메이션 재은님이 구현한거랑 겹쳐서 pr 올라오면 그거 참고해서 구현 예정
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
// 정리하려고 했으나 매주, 매달마다 백에서 전달하는 point값이 달라지고, 이를 어떻게 처리할지 생각중이라 보류
struct StatisticsCellView: View {
    @Binding var selectedOption: Int
    
    let note: String
    let point: Int
    let maxPoint: Int
    let totalPoint: Int
    
    let barWidth: CGFloat = 60
    let barHeight: CGFloat = 200
    
    
    
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
                Text(String(format: "%.1f", heightRatio * 100) + "%").font(.system(size: 13))
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
