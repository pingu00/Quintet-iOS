
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
    @ObservedObject private var viewModel = DateViewModel()
    @EnvironmentObject private var coreDataViewModel : CoreDataViewModel
    @State private var isShowingBtn = false
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
   
    
    var body: some View {
            ZStack {
                Color("Background")
                    .ignoresSafeArea(.all)
                ScrollView {
                    VStack(spacing: 30) {
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
                                        .frame(width: 300, height: 45)
                                        .cornerRadius(25)
                                        .foregroundColor(Color("LightGray2"))
                                    
                                    Rectangle()
                                        .frame(width: 155, height: 37)
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
                                    .padding(.bottom, 21)
                        }
                        
                        //날짜별
                        else {
                            CalendarView(currentDate: $currentDate)
                                .padding(.horizontal, 20)
                        }
                    }
                }
            
            }
            .modifier(CustomBackButton {
                        dismiss()
                    })
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

//요소별 밑에 나오는 카드
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
        .frame(width: 310)
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}


