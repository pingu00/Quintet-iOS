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
    
    let workTextArray: [String: String] = ["건강":"일의 중요성은 무시할 수 없습니다, 성장과 자신감을 가져다주죠. 그러나 건강도 소홀히 할 수 없는 중요한 부분입니다. 건강을 돌보는 것은 더 나은 일과 삶을 위한 기반이 됩니다. 균형 있는 일과 건강을 유지하며 생활하려면 휴식과 운동, 올바른 식습관을 챙기세요. 건강이 좋아야 일과 삶 모두에서 성취를 이룰 수 있습니다. 자신의 건강을 더욱 중요하게 생각하며 일과 건강을 조화롭게 유지하는 방법을 찾아보세요. 퀸텟은 여러분의 발전을 응원합니다.", "가족":"일에 힘쓰시는 것은 중요한 가치입니다. 그러나 가족과의 시간 또한 균형 있는 삶을 만드는 중요한 부분입니다. 가족과의 소중한 연결은 행복과 안정을 더해줄 수 있습니다. 더 많은 시간을 가족과 함께 보내고 소중한 순간을 만들어보세요. 소극적인 소통도 큰 의미를 지니며, 공동체의 지지를 받는 것이 중요합니다. 일과 가족을 모두 생각하며 균형 있는 삶을 만들어 나가길 바랍니다. 퀸텟은 여러분의 발전을 응원합니다.", "관계":"일의 열정은 가치있고, 자기만족감과 성취를 위해 중요한 부분입니다. 그러나 관계도 소홀하지 않도록 주의해야 합니다. 좋은 인간관계는 행복과 만족을 더해줄 수 있습니다. 더 많은 소통과 연결을 통해 관계를 강화하고 발전시켜보세요. 사랑하는 사람들과의 시간을 소중히 여기며 소극적인 소통도 중요합니다. 일과 관계를 함께 고려하여 균형을 찾아보세요. 퀸텟은 여러분의 발전을 응원합니다.", "자산":"일에 대한 열정을 이해합니다. 그러나 미래를 위한 자산을 놓치지 말아야 합니다. 자산을 키우는 것은 안정과 더 나은 미래를 위한 준비입니다. 저축과 투자를 통해 재정적 안정성을 높이는 방법을 탐색해보세요. 현재의 노력이 미래를 더욱 풍요롭게 만들 수 있습니다. 일과 자산을 균형 있게 고려하여 더 나은 삶을 만들어 나가길 바랍니다. 퀸텟은 여러분의 발전을 응원합니다."]
    let healthTextArray = ["일": "건강하다는 것은 집중력이 향상되고, 자신감을 가질 수 있다는 것입니다. 그러나 일의 집중도가 다소 낮은 모습을 보입니다. 일상적인 업무와 성취도 중요한 부분입니다. 균형 있는 삶을 위해 다양한 영역에 관심을 기울이는 것이 중요합니다. 일을 통해 자아실현과 경제적 안정을 얻을 수 있으며, 자산을 키우는 기회가 될 수 있습니다. 건강과 일을 조화롭게 유지하면 더 풍요로운 삶을 즐길 수 있습니다.", "가족":"건강에 집중함으로써 체력과 집중력을 가질 수 있습니다. 그러나 가족과의 관계도 매우 중요한 부분입니다. 가족과의 유대감을 강화하면 더 큰 행복과 안정을 찾을 수 있습니다. 시간을 내어 가족과 소통하고 지내는 것이 유익할 것입니다. 가족은 우리의 지원체계이자 소중한 추억을 쌓는 곳입니다. 건강과 가족을 모두 생각하며 균형 잡힌 삶을 만들어 나가길 바랍니다. 퀸텟은 여러분의 발전을 응원합니다.", "관계":"건강에 집중하면 살아가며 긍정적인 활력을 얻을 수 있습니다. 그러나 관계도 삶의 중요한 부분입니다. 좋은 관계는 행복과 만족을 더해줄 수 있습니다. 주변 사람들과의 소통과 연결은 감정적 안정과 풍요로움을 제공합니다. 관계를 더 개선하려면 더 많은 시간을 투자하고 소중한 사람들과 함께 지내는 것이 중요합니다. 소소한 만남과 소통이 큰 의미를 갖을 수 있습니다. 건강과 관계를 함께 고려하여 행복하고 균형 잡힌 삶을 만들어 나가길 바랍니다. 퀸텟은 여러분의 발전을 응원합니다.", "자산":"건강 관리는 스트레스 관리와 삶의 활력 측면에서 매우 중요합니다. 그러나 자산에도 조금 더 관심을 기울이는 것이 중요합니다. 미래를 위한 준비와 안정적인 경제적 기반은 중요한 부분입니다. 자산을 키우는 방법을 공부하고 효율적인 재정 관리를 통해 더 큰 안정을 얻을 수 있습니다. 건강과 자산을 함께 고려하여 균형 잡힌 삶을 만들어 나가길 바랍니다. 퀸텟은 여러분의 발전을 응원합니다."]
    let familyTextArray = ["일":"가족과 삶을 공유한다는 것은 매우 바람직합니다. 그러나 일 역시 중요한 요소입니다. 균형 있는 삶을 위해서는 가족과 함께 보내는 시간과 함께 일의 성과를 동시에 고려해야 합니다. 가족과의 시간을 소중히 하면서도 자신의 역량을 발휘하고 성장하는 기회를 찾아보세요. 가족과의 행복과 성과를 모두 얻을 수 있는 방법을 찾아 균형을 이루어 나가길 바랍니다.", "건강":"가족과의 관계는 정서적 안정감과 만족감을 줍니다. 그러나 건강 또한 균형 잡힌 삶을 위해 필수적입니다. 가족과 함께 행복한 순간을 만드는 동시에 건강을 돌보는 것이 중요합니다. 올바른 식습관과 꾸준한 운동을 통해 건강을 더욱 강화해보세요. 건강이 뒷받침되어야 가족과의 시간을 더욱 풍요롭게 보낼 수 있습니다. 가족과 건강 모두를 소중히 여기며 균형을 유지하는 방법을 찾아보세요.", "관계":"가족을 중요하게 생각하는 마음가짐은 좋습니다. 그러나 다양한 관계도 놓치지 않도록 노력해야 합니다. 관계를 통해 새로운 시각과 지식을 얻을 수 있으며, 인간관계는 풍요로움을 더해줄 수 있습니다. 친구, 동료, 지인과의 소중한 연결을 강화해보세요. 다양한 인간관계를 통해 더욱 풍부한 경험을 얻을 수 있을 것입니다. 가족과 관계 모두를 소중히 여기며 균형을 유지하는 방법을 찾아보세요. 퀸텟은 여러분의 발전을 응원합니다.", "자산":"가족을 우선으로 생각하는 마음가짐은 훌륭합니다. 그러나 미래를 위한 자산도 중요한 부분입니다. 가족과 함께 행복한 시간을 보내면서도, 장기적으로 자산을 쌓아나가는 방법을 고려해보세요. 저축과 투자를 통해 안정적인 경제 기반을 만들면서도 가족과의 연결을 유지할 수 있습니다. 가족의 행복과 안정을 동시에 추구하는 방법을 찾아보세요. 퀸텟은 여러분의 발전을 응원합니다."]
    let relationshipTextArray = ["일":"인간관계를 중요하게 여기시는 것은 훌륭합니다. 그러나 일 역시 삶의 중요한 부분입니다. 업무와 성취도 균형 있는 삶을 만들기 위해 필요한 요소입니다. 관계와 함께 일의 성과를 동시에 추구하는 방법을 고려해보세요. 업무에서의 성과가 더 나은 관계를 만들고, 관계의 풍성함이 업무 성과에 긍정적인 영향을 미칠 수 있습니다. 일과 관계를 함께 고려하여 균형을 이루어 나가기를 바랍니다. 퀸텟은 여러분의 발전을 응원합니다.", "건강":"인간관계는 삶의 의미를 더해주는 중요한 요소입니다. 그러나 건강도 소홀히 하지 마세요! 건강한 신체와 마음이 좋은 관계 형성을 도울 것입니다. 균형 잡힌 식단과 운동으로 건강을 관리하며, 관계를 풍성하게 만드는 데 더 큰 에너지를 투자해보세요. 건강한 상태로 더 행복한 관계를 쌓을 수 있습니다. 퀸텟은 여러분의 발전을 응원합니다.", "가족":"관계는 우리 삶에 있어서 꼭 필요한 요소 중 하나입니다. 그러나 가족과의 연결도 잊지 말아야 합니다. 가족과 소중한 시간을 보내고, 소극적인 소통으로 유대감을 강화하세요. 함께하는 순간이 더욱 풍요로운 관계를 만들어줄 것입니다. 또한, 다양한 인간관계도 큰 의미를 지니니 가까운 친구와 동료와의 관계도 고려해보세요. 퀸텟은 여러분의 발전을 응원합니다.", "자산":"관계에 집중하는 것은 사회적으로 매우 중요하고, 삶을 풍요롭게 해줄 수 있습니다. 그러나 미래를 위한 자산도 고려하세요. 자산을 키워 더 나은 미래를 준비하는 것이 중요합니다. 저축과 투자를 통해 재정적 안정성을 높이며, 미래 계획을 위한 자산을 쌓아보세요. 관계와 자산을 균형 있게 고려하며 더 풍요로운 삶을 만들어 나가길 바랍니다."]
    let assetTextArray = ["일":"자산을 중요하게 여기는 것은 바람직한 현상입니다. 그러나 우리는 삶의 다양한 측면도 고려해야 합니다. 업무와 성취를 통해 미래를 준비하면서도 여가 시간과 취미를 즐기며 균형을 찾아보세요. 자산을 키우는 동시에 삶의 즐거움도 놓치지 마세요. 퀸텟은 여러분의 발전을 응원합니다.", "건강":"자산을 쌓기 위한 노력은 훌륭합니다. 그러나 건강도 소중히 여기셔야 합니다. 건강한 상태가 자산을 유용하게 활용하는 기반이 됩니다. 균형 잡힌 식단과 운동을 통해 건강을 돌보며, 장기적으로 자산을 키우기 위한 미래 계획을 세우세요. 퀸텟은 여러분의 발전을 응원합니다.", "가족":"자산을 중시하게 생각하며 노력하는 모습은 매우 훌륭합니다. 그러나 살아가면서 가족과의 연결도 놓치지 말아야 합니다. 가족과 소중한 시간을 보내고 소극적인 소통으로 유대감을 강화하세요. 가족과의 연결이 풍요로운 자산의 의미를 더욱 크게 만들어줄 것입니다.", "관계":"자산을 쌓기 위한 노력은 항상 중요하며, 현대인이 갖추어야 할 덕목입니다. 그러나 삶의 균형을 위해서는 인간관계도 풍요롭게 유지해야 합니다. 다양한 관계를 통해 새로운 아이디어와 지식을 얻을 수 있으며, 좋은 관계는 미래의 자산을 더 가치 있게 만들어줄 것입니다. 소중한 인간관계를 키우며 자산을 지키는 방법을 찾아보세요."]
    
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
                        .padding(.bottom, 25)
                }
                VStack{
                    HStack{
                        switch selectedOption {
                            // MARK: - 주간
                        case 1:
                            HStack{
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
                        case 2:
                            HStack{
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
                        case 3:
                            HStack{
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
                    if(dateViewModel.selectedMonthFirstDay > Date()) {
                        dateViewModel.selectedYear = Calendar.current.component(.year, from: Date())
                        dateViewModel.selectedMonth = Calendar.current.component(.month, from: Date())
                    }
                }
                .padding(.bottom, -15)
                
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
                if statisticsCellViewModel.maxPoint == 0{
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
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: 330, height: nil)
                            HStack{
                                Spacer()
                                if let selectedText = selectedTextForCategory() {
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
    
    private func selectedTextForCategory() -> String? {
        guard let maxCategory = statisticsCellViewModel.maxNoteArray.first else {
            return nil
        }
        
        guard let minCategory = statisticsCellViewModel.minNoteArray.first else {
            return nil
        }
        
        var textArray = workTextArray[minCategory]
        switch maxCategory {
        case "일":
            textArray = workTextArray[minCategory]
        case "건강":
            textArray = healthTextArray[minCategory]
        case "가족":
            textArray = familyTextArray[minCategory]
        case "관계":
            textArray = relationshipTextArray[minCategory]
        case "자산":
            textArray = assetTextArray[minCategory]
        default:
            return nil
        }
        
        return textArray
    }
    
    func cellWeekUpdate() {
        let endDate = Calendar.current.date(byAdding: .day, value: 6, to: dateViewModel.startOfWeek)!
        statisticsCellViewModel.updateValuesFromCoreData(startDate: dateViewModel.startOfWeek, endDate: endDate)
    }

    func cellMonthUpdate() {
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: dateViewModel.selectedMonthFirstDay)!
        statisticsCellViewModel.updateValuesFromCoreData(startDate: dateViewModel.selectedMonthFirstDay, endDate: endDate)
    }

    func cellYearUpdate() {
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: dateViewModel.selectedYearFirstDay)!
        statisticsCellViewModel.updateValuesFromCoreData(startDate: dateViewModel.selectedYearFirstDay, endDate: endDate)
    }

    func updateStatistics() {
        if selectedOption == 1 {
            cellWeekUpdate()
        } else if selectedOption == 2 {
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

// MARK: - StatisticsCellView
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
            VStack(spacing: 4) {
                Text(note).font(.system(size: 15))
                Text(String(format: "%.1f", heightRatio * 100) + "%").font(.system(size: 11))
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
