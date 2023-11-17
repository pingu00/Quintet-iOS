//
//  PickerView.swift
//  Quintet-iOS
//
//  Created by 김영준 on 2023/08/12.
//

import SwiftUI

// MARK: - YearMonthPickerPopup
struct YearMonthPickerPopup: View {
    @ObservedObject var viewModel: DateViewModel
    @Binding var isShowPopup: Bool
    @Binding var selectedOption: String
    
    @State private var oldSelectedYear: Int
    @State private var oldSelectedMonth: Int
        
    init(viewModel: DateViewModel, isShowPopup: Binding<Bool>, selectedOption: Binding<String>) {
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
                    if selectedOption == "월간"{
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
