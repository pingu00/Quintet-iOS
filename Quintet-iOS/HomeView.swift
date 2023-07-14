//
//  ContentView.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI

struct HomeView: View {
    @State private var month = 6
    @State private var date = 15
    @State private var week = "목"
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                //메뉴 버튼
                Button(action: {
                    print("Menu Btn Tapped")
                }, label: {
                    Image(systemName: "line.3.horizontal")
                })
                .tint(.black)
                .padding(.horizontal)
            }.padding(.vertical)
        
            ScrollView {
                VStack{
                    HStack{
                        Text("\(month)월 \(date)일 \(week)요일")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .padding(.leading, 5)
                        Spacer()
                    }
                    Divider()
                        .frame(height: 0.6)
                        .background(Color(hex: 0xCCCCCC))
                        .padding(.vertical)
                    // MARK: - 요일 Section
                    HStack{
                        WeekCellView(week: "일", date: 9, is_selected: false, is_today: true, has_record: false)
                        WeekCellView(week: "월", date: 10, is_selected: false, is_today: true, has_record: true)
                        WeekCellView(week: "화", date: 11, is_selected: true, is_today: true, has_record: false)
                        WeekCellView(week: "수", date: 12, is_selected: false, is_today: true, has_record: true)
                        WeekCellView(week: "목", date: 13, is_selected: false, is_today: true, has_record: true)
                        WeekCellView(week: "금", date: 14, is_selected: false, is_today: true, has_record: false)
                        WeekCellView(week: "토", date: 15, is_selected: false, is_today: true, has_record: true)
                        
                    }.padding()
                    
                    HStack{
                        Text("퀸텟체크 기록이 없습니다.")
                    }.padding()
                    
                    Divider()
                        .frame(height: 0.6)
                        .background(Color(hex: 0xCCCCCC))
                        .padding(.vertical)
                    
                    // MARK: - 오늘의 퀸텟 체크 Section
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                        HStack{
                            Text("오늘의 \n퀸텟체크")
                                .font(.system(size: 28))
                                .fontWeight(.bold)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 30)
                            Spacer()
                            VStack{
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .tint(Color(hex: 0x484848))
                                    .font(.title)
                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 30)
                        }
                    }
                    .padding(.bottom)
                    
                    // MARK: - 분석확인, 기록확인 Section
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                        VStack{
                            HStack(alignment: .center){
                                VStack(alignment: .leading){
                                    Text("지난주 분석 확인하기")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 18))
                                        .padding(.bottom, 0.5)
                                    Text("2023. 06. 04 - 2023. 06. 10")
                                        .font(.system(size: 14))
                                }.padding()

                                Spacer()
                                Image(systemName: "chevron.right")
                                    .tint(Color(hex: 0x484848))
                                    .font(.title)
                                    .padding()
                            }.padding()
                            
                            Divider()
                                .background(Color(hex: 0xCCCCCC))
                                .padding(.horizontal)
                            
                            HStack(alignment: .center){
                                Text("기록 확인하기")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 18))
                                    .padding()

                                Spacer()
                                Image(systemName: "chevron.right")
                                    .tint(Color(hex: 0x484848))
                                    .font(.title)
                                    .padding()

                            }.padding()
                        }.padding(.bottom, 10)
                    }
                    
                    // MARK: - 추천 영상 Section
                    HStack{
                        Text("추천 영상으로\n행복을 챙겨요")
                            .fontWeight(.semibold)
                            .font(.system(size: 30))
                            .padding()
                        Spacer()
                    }.padding(.vertical, 10)
                    
                    VStack{
                        HStack{
                            //각 영상 cell을 등록
                            VideoCellView(videoURL: "video1", videoTitle: "건강한 삶을 위한 규칙적인 식습관", thumbnail: "video1")
                                .padding(.leading)
                            Spacer()
                                .frame(width: 10)
                            VideoCellView(videoURL: "video2", videoTitle: "인간관계에서 편해지는 법", thumbnail: "video2")
                                .padding(.trailing)
                        }.padding(.bottom)
                        VideoCellView(videoURL: "video3", videoTitle: "월급의 몇 %를 저축하고 있나요?", thumbnail: "video3")
                            .padding(.horizontal)
                    }
                }
                .padding(20)
            }
        }
        .background(Color(hex: 0xF5F5F5))
    }
        
}

// MARK: - 요일 cell
struct WeekCellView: View{
    let week : String //요일
    let date : Int //날짜
    var is_selected: Bool //해당 셀이 선택 되었는지
    let is_today: Bool //해당 요일이 오늘의 요일인지
    let has_record : Bool //해당 날짜에 기록이 있는지
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(getForegroundColor())
                .frame(width: 40, height: 90)
            VStack{
                Text(week)
                    .foregroundColor(getTextColor())
                    .padding(.bottom)
                Text("\(date)")
                    .foregroundColor(getTextColor())
                    .fontWeight(.bold)
            }
        }
        
    }
    
    //요일 박스의 색을 결정한다. 선택되어 있다면 파란색, 아니라면 기록 유무에 따라 색을 결정
    private func getForegroundColor() -> Color {
        if is_selected{
            return Color(hex: 0x5B62FF)
        } else {
            return has_record ? Color(hex: 0xE4E4E4) : .clear
        }
    }
    
    //요일 박스의 글자 색을 결정한다. (흰색 또는 검은색)
    private func getTextColor() -> Color {
        if is_selected{
            return Color(hex: 0xFFFFFF)
        } else {
            return Color(hex: 0x4A4A4A)
        }
    }
    
}

// MARK: - video cell
struct VideoCellView: View{
    let videoURL: String
    let videoTitle: String
    let thumbnail: String
    
    var body: some View{
        ZStack{
            Image(thumbnail)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack{
                Spacer()
                HStack{
                    Text(videoTitle)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .padding()
                    Spacer()
                }
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
