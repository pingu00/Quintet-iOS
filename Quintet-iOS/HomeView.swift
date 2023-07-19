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
    @State private var selectDayIndex = 4
    private var dummyData = DummyDataManager.getDummyData()
    private var dateManager = DateManager()
    @State private var selectDateData : HappinessInfo? //선택한 날의 날짜 정보, 퀸텟 체크 기록이 담겨 있음.
    
    var body: some View {
        VStack{
            NavigationView {
                VStack{
                    NavigationLink(destination: QuintetCheckView()) { //임시로 연결해준 뷰
                        Spacer()
                        Image(systemName: "line.3.horizontal").padding()
                            .tint(.black)
                    }
                    
                    ScrollView {
                        VStack{
                            HStack{
                                Text(dateManager.getTodayText())
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                    .padding(.leading, 5)
                                Spacer()
                            }
                            Divider()
                                .frame(height: 0.6)
                                .background(Color("LightGray"))
                                .padding(.vertical)
                            // MARK: - 요일 Section
                            HStack{
                                WeekCellView(happinessInfo: dummyData[0], is_selected: selectDayIndex == 0)
                                    .onTapGesture {
                                        selectDayIndex = 0
                                        selectDateData = dummyData[0]
                                    }
                                WeekCellView(happinessInfo: dummyData[1], is_selected: selectDayIndex == 1)
                                    .onTapGesture {
                                        selectDayIndex = 1
                                        selectDateData = dummyData[1]
                                    }
                                WeekCellView(happinessInfo: dummyData[2], is_selected: selectDayIndex == 2)
                                    .onTapGesture {
                                        selectDayIndex = 2
                                        selectDateData = dummyData[2]
                                    }
                                WeekCellView(happinessInfo: dummyData[3], is_selected: selectDayIndex == 3)
                                    .onTapGesture {
                                        selectDayIndex = 3
                                        selectDateData = dummyData[3]
                                    }
                                WeekCellView(happinessInfo: dummyData[4], is_selected: selectDayIndex == 4)
                                    .onTapGesture {
                                        selectDayIndex = 4
                                        selectDateData = dummyData[4]
                                    }
                                WeekCellView(happinessInfo: dummyData[5], is_selected: selectDayIndex == 5)
                                    .onTapGesture {
                                        selectDayIndex = 5
                                        selectDateData = dummyData[5]
                                    }
                                WeekCellView(happinessInfo: dummyData[6], is_selected: selectDayIndex == 6)
                                    .onTapGesture {
                                        selectDayIndex = 6
                                        selectDateData = dummyData[6]
                                    }
                            }
                            .padding()
                            
                            // MARK: - 선택한 날짜에 퀸텟 기록이 있으면 보여주고, 없으면 없다는 메세지를 보여줌
                            if let happinessData = selectDateData?.happiness{
                                HappinessView(happinessData: happinessData)
                            }
                            else{
                                Text("퀸텟체크 기록이 없습니다.")
                            }
                            Divider()
                                .frame(height: 0.6)
                                .background(Color("LightGray"))
                                .padding(.vertical)
                            
                            // MARK: - 오늘의 퀸텟 체크 Section
                            ZStack{
                                Button {
                                    print("오늘의 퀸텟 체크 tapped")
                                } label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.white)
                                }
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
                                            .tint(.black)
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
                                    ZStack{
                                        Button {
                                            print("지난주 분석 확인하기 tapped")
                                        } label: {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.white)
                                        }
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
                                                .tint(.black)
                                                .font(.title)
                                                .padding()
                                        }
                                    }.padding()
                                    
                                    Divider()
                                        .background(Color("LightGray"))
                                        .padding(.horizontal)
                                    ZStack{
                                        Button {
                                            print("기록 확인하기 tapped")
                                        } label: {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.white)
                                        }
                                        HStack(alignment: .center){
                                            Text("기록 확인하기")
                                                .fontWeight(.semibold)
                                                .font(.system(size: 18))
                                                .padding()
                                            
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .tint(.black)
                                                .font(.title)
                                                .padding()
                                            
                                        }.padding()
                                    }
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
                .background(Color("Background"))
            }
        }
    }
}

// MARK: - 요일 cell
struct WeekCellView: View{
    let dateManager = DateManager()
    let happinessInfo : HappinessInfo
    var is_selected: Bool //해당 셀이 선택 되었는지
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(getForegroundColor())
                .frame(width: 40, height: 90)
            VStack{
                Text(dateManager.get_week(dateStr: happinessInfo.date))
                    .foregroundColor(getTextColor())
                    .padding(.bottom)
                    .fontWeight(.light)
                Text(dateManager.get_day(dateStr: happinessInfo.date))
                    .foregroundColor(getTextColor())
                    .fontWeight(.semibold)
            }
        }
    }
    
    //요일 박스의 색을 결정한다. 선택되어 있다면 파란색, 아니라면 기록 유무에 따라 색을 결정
    private func getForegroundColor() -> Color {
        if is_selected{
            return Color("DarkQ")
        } else {
            if(dateManager.is_today(dateStr: happinessInfo.date)) {
                return Color("DarkGray")
            }
            else {
                if happinessInfo.happiness != nil{return Color("LightGray2")}
                else{return .clear}
            }
        }
    }
    
    //요일 박스의 글자 색을 결정한다. (흰색 또는 검은색)
    private func getTextColor() -> Color {
        if is_selected || dateManager.is_today(dateStr: happinessInfo.date){
            return Color("White")
        } else {
            return Color("Black")
        }
    }
    
}

// MARK: - 일, 건강, 가족, 관계, 자산 5가지 퀸텟 지수를 나타내는 cell
struct HappinessCell: View{
    let type: String
    let value: Int
    
    var body: some View{
        HStack{
            Text(type)
                .fontWeight(.medium)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            switch value{
            case 0:
                Image("XOn")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 22, maxHeight: 22)
            case 1:
                Image("TriangleOn")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 22, maxHeight: 22)
            default:
                Image("CircleOn")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 22, maxHeight: 22)
            }
        }
    }
}

// MARK: - 5가지 퀸텟 지수 Cell을 모아둔 view. 퀸텟 체크 기록이 있어야 나타난다.
struct HappinessView: View{
    let happinessData : [Int]
    
    var body: some View{
        HStack{
            HappinessCell(type: "일", value: happinessData[0])
            Spacer()
            HappinessCell(type: "건강", value: happinessData[1])
            Spacer()
            HappinessCell(type: "가족", value: happinessData[2])
            Spacer()
            HappinessCell(type: "관계", value: happinessData[3])
            Spacer()
            HappinessCell(type: "자산", value: happinessData[4])
        }.padding(.horizontal)
    }
}


// MARK: - video cell
struct VideoCellView: View{
    let videoURL: String
    let videoTitle: String
    let thumbnail: String
    
    var body: some View{
        ZStack{
            Button {
                print("video cell tapped")
                UIApplication.shared.open(URL(string: "https://www.youtube.com/watch?v=OIV6peKMj9M")!) //임시 주소
                print("there's something in the Air")
            } label: {
                Image(thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
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

// MARK: - 날짜에 관련된 다양한 기능을 수행하는 구조체 **날짜 data를 어떻게 받느냐에 따라 수정 필요**
struct DateManager{
    let today = Date()
    
    //"M월 d일 E요일" 형식으로 오늘의 날짜를 반환해줌
    func getTodayText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        return dateFormatter.string(from: today)
    }
    
    //날짜 string을 기반으로 해당 날짜가 오늘인지 판단하는 함수
    func is_today(dateStr: String) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd-EEE"
        let todayStr = dateFormatter.string(from: today)
        
        return dateStr == todayStr
    }
    
    //날짜 string을 기반으로 그날의 일자를 string으로 반환해주는 함수
    func get_day(dateStr: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-EEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if let date = dateFormatter.date(from: dateStr) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "dd"
            return dayFormatter.string(from: date)
        } else {return "Invalid Date"}
    }
    
    //날짜 string을 기반으로 그날의 요일을 string으로 반환해주는 함수
    func get_week(dateStr: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-EEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if let date = dateFormatter.date(from: dateStr) {
            let weekFormatter = DateFormatter()
            weekFormatter.locale = Locale(identifier: "ko_KR")
            weekFormatter.dateFormat = "EEE"
            return weekFormatter.string(from: date)
        } else {return "Invalid Date"}
    }
}

// MARK: - 임시로 만든 더미 데이터 type
struct HappinessInfo{
    var date: String
    var happiness : [Int]?
}

// MARK: - 임시 data를 관리하는 class
class DummyDataManager{
   static var data: [HappinessInfo] = [
        HappinessInfo(date: "2023-07-16-일", happiness: [1, 2, 2, 0, 1]),
        HappinessInfo(date: "2023-07-17-월"),
        HappinessInfo(date: "2023-07-18-화", happiness: [1, 2, 1, 0, 0]),
        HappinessInfo(date: "2023-07-19-수"),
        HappinessInfo(date: "2023-07-20-목"),
        HappinessInfo(date: "2023-07-21-금", happiness: [1, 1, 2, 0, 1]),
        HappinessInfo(date: "2023-07-22-토", happiness: [0, 2, 2, 0, 1])
    ]
    
    static func getDummyData() -> [HappinessInfo]{
        return self.data
    }
}
