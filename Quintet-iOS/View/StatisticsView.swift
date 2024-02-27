//
//  StatisticsView.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI

struct StatisticsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isLogin = KeyChainManager.read(forkey: .isNonMember) == "true"
//    @State private var isLogin = true
    
    @StateObject private var dateViewModel = DateViewModel()
    @StateObject private var statisticsCellViewModel = StatisticsCellViewModel()
    @StateObject private var statisticsCellViewModel_login = StatisticsCellViewModel_login.shared
    
    @State private var selectedOption = "주간"
    @State private var isShowPopup = false
    
    var body: some View {
        ZStack {
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
                            HStack {
                                DateOptionView(text: "주간", selectedOption: $selectedOption)
                                DateOptionView(text: "월간", selectedOption: $selectedOption)
                                DateOptionView(text: "연간", selectedOption: $selectedOption)
                            }
                        )
                        .padding(.bottom, 25)
                }
                VStack {
                    HStack {
                        switch selectedOption {
                            // MARK: - 주간
                        case "주간":
                            HStack {
                                ArrowButton(action: {
                                    dateViewModel.startOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: dateViewModel.startOfWeek)!
                                    cellWeekUpdate()
                                }, imageName: "chevron.backward", isDisabled: dateViewModel.startOfWeek == Calendar.current.date(from: DateComponents(weekOfYear: 1, yearForWeekOfYear: 2017)))
                                
                                Spacer()
                                
                                dateViewModel.weekButtonText
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                ArrowButton(action: {
                                    dateViewModel.startOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: dateViewModel.startOfWeek)!
                                    cellWeekUpdate()
                                }, imageName: "chevron.forward", isDisabled: dateViewModel.startOfWeek == Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!)
                            }
                            .frame(width: 300)
                            // MARK: - 월간
                        case "월간":
                            HStack {
                                ArrowButton(action: {
                                    dateViewModel.selectedMonth -= 1
                                    if dateViewModel.selectedMonth < 1 {
                                        dateViewModel.selectedMonth = 12
                                        dateViewModel.selectedYear -= 1
                                    }
                                    cellMonthUpdate()
                                }, imageName: "chevron.backward", isDisabled: dateViewModel.selectedYear == 2017 && dateViewModel.selectedMonth == 1)
                                
                                Spacer()
                                
                                Button(action: {
                                    isShowPopup = true
                                }) {
                                    dateViewModel.yearMonthButtonText
                                        .foregroundColor(.black)
                                    Image(systemName: "arrowtriangle.down.circle").foregroundColor(.gray)
                                }
                                Spacer()
                                                                    
                                ArrowButton(action: {
                                    dateViewModel.selectedMonth += 1
                                    if dateViewModel.selectedMonth > 12 {
                                        dateViewModel.selectedMonth = 1
                                        dateViewModel.selectedYear += 1
                                    }
                                    cellMonthUpdate()
                                }, imageName: "chevron.forward", isDisabled: dateViewModel.selectedYear == Calendar.current.component(.year, from: Date()) && dateViewModel.selectedMonth == Calendar.current.component(.month, from: Date()))
                            }
                            .frame(width: 300)
                            // MARK: - 연간
                        case "연간":
                            HStack {
                                ArrowButton(action: {
                                    dateViewModel.selectedYear -= 1
                                    cellYearUpdate()
                                }, imageName: "chevron.backward", isDisabled: dateViewModel.selectedYear == 2017)
                                
                                Spacer()
                                
                                Button(action: {
                                    isShowPopup = true
                                }) {
                                    dateViewModel.yearButtonText
                                        .foregroundColor(.black)
                                    Image(systemName: "arrowtriangle.down.circle").foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                ArrowButton(action: {
                                    dateViewModel.selectedYear += 1
                                    cellYearUpdate()
                                }, imageName: "chevron.forward", isDisabled: dateViewModel.selectedYear == Calendar.current.component(.year, from: Date()))
                            }
                            .frame(width: 300)
                        default:
                            Text("")
                        }
                    }
                }
                .onChange(of: dateViewModel.selectedMonthFirstDay) { newValue in
                    updateStatistics()
                }
                .onChange(of: selectedOption) { newValue in
                    updateStatistics()
                    if (dateViewModel.selectedMonthFirstDay > Date()) {
                        dateViewModel.selectedYear = Calendar.current.component(.year, from: Date())
                        dateViewModel.selectedMonth = Calendar.current.component(.month, from: Date())
                    }
                }
                .padding(.bottom, -15)
                
                VStack {
                    HStack(spacing: 0) {
                        ForEach(isLogin ? statisticsCellViewModel_login.noteArray : statisticsCellViewModel.noteArray, id: \.1) { (point, note) in
                            StatisticsCellView(
                                selectedOption: $selectedOption,
                                note: note,
                                point: point,
                                maxPoint: Double(isLogin ? statisticsCellViewModel_login.maxPoint : statisticsCellViewModel.maxPoint),
                                totalPoint: Double(isLogin ? 100 : statisticsCellViewModel.totalPoint)
                            )
                            .onAppear {
                                if isLogin {
                                    statisticsCellViewModel_login.updateNoteArray()
                                }
                            }
                        }
                    }
                    Divider()
                        .background(Color.gray)
                        .frame(width: 330)
                        .padding(.top, 40)
                }
                .padding(20)
                if isLogin ? statisticsCellViewModel_login.maxPoint.isNaN || statisticsCellViewModel_login.maxPoint == 0 : statisticsCellViewModel.maxPoint == 0 {
                    VStack{
                        Text("기록된 데이터가 없어요...")
                            .padding(.top, 20)
                    }
                }
                else {
                    VStack {
                        HStack(spacing: 0) {
                            Group {
                                switch selectedOption {
                                case "주간":
                                    Text("이번 주는 ")
                                        .font(.system(size: 26))
                                        .multilineTextAlignment(.center)
                                case "월간":
                                    Text("이번 달은 ")
                                        .font(.system(size: 26))
                                        .multilineTextAlignment(.center)
                                case "연간":
                                    Text("올해는 ")
                                        .font(.system(size: 26))
                                        .multilineTextAlignment(.center)
                                default:
                                    Text("")
                                }
                            }
                            Text(isLogin ? statisticsCellViewModel_login.maxNoteArray.joined(separator: ", ") : statisticsCellViewModel.maxNoteArray.joined(separator: ", "))
                                .bold()
                                .font(.system(size: 26))
                                .multilineTextAlignment(.center)
                            Text("에")
                                .font(.system(size: 26))
                                .multilineTextAlignment(.center)
                        }
                        VStack {
                            Text("주로 집중하셨군요!")
                                .font(.system(size: 26))
                                .multilineTextAlignment(.center)
                        }
                    }
                    VStack{
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: 330, height: nil)
                            HStack {
                                Spacer()
                                if let selectedText = isLogin ? statisticsCellViewModel_login.selectedText : statisticsCellViewModel.selectedText {
                                    Text(selectedText)
                                        .font(.system(size: 16))
                                        .multilineTextAlignment(.leading)
                                        .lineSpacing(3)
                                        .padding(35)
                                        .frame(width: 320, height: nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .modifier(CustomBackButton {
                    dismiss()
                })
        .onAppear {
            print("로그인 여부: \(isLogin)")
            if isLogin {
                cellWeekUpdate()
            }
        }
        .sheet(isPresented: $isShowPopup) {
            YearMonthPickerPopup(viewModel: dateViewModel, isShowPopup: $isShowPopup, selectedOption: $selectedOption)
                .frame(width: 300, height: 400)
                .clearModalBackground()
                .ignoresSafeArea()
        }
    }
    
    func cellWeekUpdate() {
        let endDate = Calendar.current.date(byAdding: .day, value: 6, to: dateViewModel.startOfWeek)!
        if !isLogin {
            statisticsCellViewModel.updateValuesFromCoreData(startDate: dateViewModel.startOfWeek, endDate: endDate)
        } else {
            statisticsCellViewModel_login.updateValuesFromAPI_Week(startDate: dateViewModel.startOfWeek, endDate: endDate)
        }
    }

    func cellMonthUpdate() {
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: dateViewModel.selectedMonthFirstDay)!
        if !isLogin {
        statisticsCellViewModel.updateValuesFromCoreData(startDate: dateViewModel.selectedMonthFirstDay, endDate: endDate)
        } else {
            statisticsCellViewModel_login.updateValuesFromAPI_Month(year:dateViewModel.selectedYearFirstDay, month: dateViewModel.selectedMonthFirstDay)
        }
    }

    func cellYearUpdate() {
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: dateViewModel.selectedYearFirstDay)!
        if !isLogin {
        statisticsCellViewModel.updateValuesFromCoreData(startDate: dateViewModel.selectedYearFirstDay, endDate: endDate)
        } else {
            statisticsCellViewModel_login.updateValuesFromAPI_Year(year: dateViewModel.selectedYearFirstDay)
        }
    }

    func updateStatistics() {
        if selectedOption == "주간" {
            cellWeekUpdate()
        } else if selectedOption == "월간" {
            cellMonthUpdate()
        } else {
            cellYearUpdate()
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
struct DateOptionView: View {
    var text: String
    @Binding var selectedOption: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(selectedOption == text ? Color("DarkGray") : Color("LightGray2"))
            .frame(width: 90, height: 35)
            .overlay(
                Text(text)
                    .foregroundColor(selectedOption == text ? Color.white : Color.black)
            )
            .onTapGesture {
                selectedOption = text
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

struct ClearBackgroundViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content
                .presentationBackground(.clear)
        } else {
            content
                .background(BackgroundClearView())
        }
    }
}

extension View {
    func clearModalBackground()->some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}

// MARK: - StatisticsCellView
struct StatisticsCellView: View {
    @Binding var selectedOption: String
    
    let note: String
    let point: Double
    let maxPoint: Double
    let totalPoint: Double
    
    let barWidth: CGFloat = 60
    let barHeight: CGFloat = 200
    
    var body: some View {
        let heightRatio: CGFloat = totalPoint != 0 ? CGFloat(point) / CGFloat(totalPoint) : 0
        
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
            VStack(spacing: 4) {
                Text(note).font(.system(size: 15))
                Text(heightRatio.isNaN ? "0.0%" : String(format: "%.1f", heightRatio * 100) + "%")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
