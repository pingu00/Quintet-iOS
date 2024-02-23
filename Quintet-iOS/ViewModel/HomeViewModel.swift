//
//  HomeViewModel.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/08/10.
//

import SwiftUI

class HomeViewModel: CoreDataViewModel { //CoreDataViewModel 상속
    @Published var isNeedUpdate: Bool
    @Published var selectDay: Date
    @Published var quintetDataArray: [QuintetData] = []
    
    let calendar = Calendar.current
    let startDate: Date
    let endDate: Date
    let previousStartDate: Date
    let previousEndDate: Date

    private let dateProcessingModel: DateProcessingModel
    
    override init(){
        self.dateProcessingModel = DateProcessingModel()
        isNeedUpdate = false
        startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        endDate = calendar.date(byAdding: .day, value: 6, to: startDate)!
        selectDay = calendar.startOfDay(for: Date())
        previousStartDate = calendar.date(byAdding: .day, value: -7, to: startDate)!
        previousEndDate = calendar.date(byAdding: .day, value: -1, to: startDate)!
        
        super.init()
        quintetDataArray = getQuintetData(from: startDate, to: endDate)
    }

    func updateValuesFromCoreData(startDate: Date, endDate: Date) {
        quintetDataArray = getQuintetData(from: startDate, to: endDate)
        for data in quintetDataArray{
//            print(data)
        }
    }

    func getSelectDayData(date: Date) -> QuintetData?{
        for data in quintetDataArray{
            if dateProcessingModel.isSameDay(date1: date, date2: data.date!){
//                print(data)
                return data }
        }
        return nil
    }
    
    func setSelectDay(index: Int){
        selectDay = calendar.date(byAdding: .day, value: index, to: startDate)!
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool{
        return dateProcessingModel.isSameDay(date1: date1, date2: date2)
    }
    
    func getDate(index: Int) -> Date{
        return calendar.date(byAdding: .day, value: index, to: startDate)!
    }
    
    func getTodayString() -> String{ //MM월 dd일 형식으로 반환해줌
        return dateProcessingModel.formatTodayToString()
    }
    
    func getDateString(date: Date) -> String{ //yyyy. MM. dd 형식으로 반환해줌
        return dateProcessingModel.convertDateToString(date: date)
    }
    
    func getDayString(date: Date) -> String{ //dd 형식으로 반환해줌
        return dateProcessingModel.convertDateToDayString(date: date)
    }
    
    func getWeekDayString(date: Date) -> String{ //E 형식으로 반환해줌
        return dateProcessingModel.convertDateToWeekDayString(date: date)
    }
}

