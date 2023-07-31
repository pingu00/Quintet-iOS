//
//  QuintetCheckView.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI

struct QuintetCheckView: View {
    @StateObject private var vm = CoreDataViewModel()
    
    @Environment(\.dismiss) private var dismiss
    @State private var hasAddNote = false
    @State private var isComplete = false
    
    @State private var workPoint = -1
    @State private var healthPoint = -1
    @State private var familyPoint = -1
    @State private var relationshipPoint = -1
    @State private var assetPoint = -1
    
    @State private var workNote = ""
    @State private var healthNote = ""
    @State private var familyNote = ""
    @State private var relationshipNote = ""
    @State private var assetNote = ""
    
    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea(.all)
            if !isComplete { //완료 아님
                ScrollView{
                    VStack{
                        Group {
                            if hasAddNote {
                                Text("자유롭게 \n 더 기록해보세요!")
                                    .font(.system(size: 30, weight: .semibold))
                            } else {
                                Text("오늘의 퀸텟체크")
                                    .font(.system(size: 30, weight: .semibold))
                            }
                        }
                        .multilineTextAlignment(.center)
                        .padding()
                        
                        if !hasAddNote{ // 완료 아니고 노트도 없음
                            VStack (spacing: 18){
                                CheckCellView (part: "일", point : $workPoint)
                                CheckCellView (part: "건강", point : $healthPoint)
                                CheckCellView (part: "가족", point : $familyPoint)
                                CheckCellView (part: "관계", point : $relationshipPoint)
                                CheckCellView (part: "자산", point : $assetPoint)
                            }
                        }
                        else { // 완료 아닌데 노트 있음
                            VStack(spacing: 18){
                                AddNoteCellView(part: "일",symbol: "pencil", note: $workNote)
                                AddNoteCellView(part: "건강",symbol: "cross.circle.fill", note : $healthNote)
                                AddNoteCellView(part: "가족",symbol: "heart.fill", note: $familyNote)
                                AddNoteCellView(part: "관계",symbol: "person.3.fill", note: $relationshipNote)
                                AddNoteCellView(part: "자산",symbol: "dollarsign.circle.fill", note: $assetNote)
                            }
                        }
                        Spacer(minLength: 102)
                        
                        Button(action: {
                            isComplete = true
                        }) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(workPoint == -1 || familyPoint == -1 || relationshipPoint == -1 || assetPoint == -1 || healthPoint == -1 ? Color("DarkGray") : Color("DarkQ"))
                                .frame(width: 345, height: 66)
                                .overlay(
                                    hasAddNote ? Text("기록완료") : Text("체크완료")
                                )
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .disabled(workPoint == -1 || familyPoint == -1 || relationshipPoint == -1 || assetPoint == -1 || healthPoint == -1)
                        
                        .padding(.vertical)
                    }
                }
            }
            
            else { // 완료임
                VStack {
                    Spacer()
                    Image("CheckMark")
                    Group {
                        if hasAddNote {
                            Text("기록이 \n 완료되었습니다!")
                        } else {
                            Text("체크가 \n 완료되었습니다!")
                            
                        }
                    }
                    .font(.system(size: 30, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding()
                    
                    Spacer()
                    Button(action: {
                        if (vm.currentQuintetData != nil) {
                            vm.updateQuintetData(Date(),workPoint, healthPoint, familyPoint, relationshipPoint, assetPoint, workNote, healthNote, familyNote, relationshipNote, assetNote)
                        } else {
                            // Add initial data for the current date
                            vm.addQuintetData(workPoint, healthPoint, familyPoint, relationshipPoint, assetPoint, workNote, healthNote, familyNote, relationshipNote, assetNote)
                        }
                        
                        dismiss()
                    }){
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("DarkQ"))
                            .frame(width: 345, height: 66)
                            .overlay(
                                Text("완료하기")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            )
                        
                    }
                    if !hasAddNote { // 완료이고 노트 없음
                        Button(action: { // 추가기록 해야하니 노트있게하고 완료는 false
                            hasAddNote = true
                            isComplete = false
                        }){
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("Background"))
                                .frame(width: 345, height: 66)
                                .overlay(
                                    Text("추가 기록하기")
                                        .foregroundColor(Color("DarkQ"))
                                        .font(.system(size: 20))
                                )
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            loadCurrentData()
            vm.checkAllCoreData()
        }
        .toolbar {
            if !isComplete {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button (action:
                                {dismiss()}){
                        Image(systemName: "chevron.backward")
                            .bold()
                            .foregroundColor(Color(.black))
                        
                    }
                }
            }
        }
    }
    private func loadCurrentData() {
        print("Current Time? : \(Date())")
        print("Today Has Data? :  \(vm.hasDataForCurrentDate())")
        if vm.hasDataForCurrentDate() {
            guard let currentQuintetData = vm.currentQuintetData else {
                return
            }
            workPoint = Int(currentQuintetData.workPoint)
            healthPoint = Int(currentQuintetData.healthPoint)
            familyPoint = Int(currentQuintetData.familyPoint)
            relationshipPoint = Int(currentQuintetData.relationshipPoint)
            assetPoint = Int(currentQuintetData.assetPoint)
            
            workNote = currentQuintetData.workNote ?? ""
            healthNote = currentQuintetData.healthNote ?? ""
            familyNote = currentQuintetData.familyNote ?? ""
            relationshipNote = currentQuintetData.relationshipNote ?? ""
            assetNote = currentQuintetData.assetNote ?? ""
        }
    }
}


struct QuintetCheckView_Previews: PreviewProvider {
    static var previews: some View {
        QuintetCheckView()
    }
}
