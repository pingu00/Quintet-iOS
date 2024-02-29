//
//  CalendarView.swift
//  Quintet-iOS
//
//  Created by 옥재은 on 2023/11/10.
//

import SwiftUI

struct CalendarView: View {
    @Binding var currentDate: Date
    @StateObject private var viewModel = DateViewModel()
    @ObservedObject private var coreDataViewModel = CoreDataViewModel()
    @ObservedObject private var recordLoginViewModel = RecordLoginViewModel()
    @State private var selectedDate = Date()
    @State private var isShowPopup = false
    @State var currentMonth: Int = 0
    let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    let invalidDayValue = -1
    private let hasLogin = /*KeyChainManager.hasKeychain(forkey: .accessToken)*/false
    @State private var getCalendarData: [CalendarMetaData] = []
    
    var body: some View {
        
        VStack(spacing: 13) {
            
            HStack(spacing: -7){
                
                Button(action: {
                    isShowPopup = true
                }) {
                    viewModel.yearMonthButtonTextRecordVer
                        .padding(.horizontal)
                        .foregroundColor(.black)
                    
                }.sheet(isPresented: $isShowPopup) {
                    CalendarYearMonthPickerPopup(viewModel: viewModel, isShowPopup: $isShowPopup)
                        .frame(width: 300, height: 400)
                        .background(BackgroundClearView())
                        .ignoresSafeArea()
                }
                
                Image(systemName: isShowPopup ? "chevron.up" : "chevron.down")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
            }
            .padding(.bottom, 17)
            
            HStack(spacing: 2) {
                
                ForEach(days, id: \.self) { day in
                    
                    Text(day)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                        .foregroundColor(Color("DarkGray"))
                }
            }
            
            Divider()
                .padding(.horizontal)
            
            let columns = Array(repeating: GridItem(.fixed(41)), count: 7)
            LazyVGrid(columns: columns, spacing: 9) {
                ForEach(extractDate()) { value in
                    if value.day != invalidDayValue {
                        CardView(value: value)
                            .background (
                                Circle()
                                    .frame(width: 40, height: 40)
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
            .onAppear {
                    loadRecords()
                }
        }
        
        if let task = getCalendarData
            .first(where: { task in
                return isSameDay(date1: task.date, date2: currentDate) &&
                       viewModel.selectedYear == Calendar.current.component(.year, from: currentDate) &&
                       viewModel.selectedMonth == Calendar.current.component(.month, from: currentDate)
            })
            {
                VStack {
                    Text("오늘의 5요소")
                        .font(.system(size: 23))
                        .fontWeight(.semibold)
                        .padding(.trailing, 190)
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                        .foregroundColor(.black)
                    
                    ForEach(task.records) { record in
                                            recordCard(
                                                icon: record.icon,
                                                title: record.title,
                                                subtitle: record.subtitle
                                            )
                    }
                }
                .onChange(of: currentMonth) { newValue in
                    viewModel.selectedYear = Calendar.current.component(.year, from: currentDate)
                    viewModel.selectedMonth = Calendar.current.component(.month, from: currentDate)
                    currentDate = getCurrentMonth()
                }
        }
    }
        
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        ZStack {
            if value.day != -1 {
                if let task = getCalendarData.first (where: { task in
                    return isSameDay(date1: task.date, date2: value.date)
                }) {
                    Circle()
                        .fill(isSameDay(date1: task.date, date2: currentDate) ? .white : Color("LightGray2") )
                        .frame(width: 40, height: 40)
                        .opacity(isSameDay(date1: task.date, date2: currentDate) ? 0 : 1)
                        .padding(.vertical, -5)
                        .onTapGesture {
                            currentDate = value.date
                        }

                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: task.date, date2: currentDate) ? .white : Color("DarkGray"))
                        .frame(maxWidth: .infinity)
                    
                } else {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date , date2: currentDate) ? .white : Color("DarkGray"))
                        .frame(maxWidth: .infinity)

                    Spacer()
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    func loadRecords() {
        if hasLogin {
            recordLoginViewModel.getCalendar(year: viewModel.selectedYear, month: viewModel.selectedMonth) { processedData in
                DispatchQueue.main.async {
                    self.getCalendarData = processedData
                }
            }
        } else {
            coreDataViewModel.getRecordMetaData(selectedYear: viewModel.selectedYear, selectedMonth: viewModel.selectedMonth) { processedData in
                DispatchQueue.main.async {
                    self.getCalendarData = processedData
                }
            }
        }
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

