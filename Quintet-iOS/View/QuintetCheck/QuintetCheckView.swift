//
//  QuintetCheckView.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI

struct QuintetCheckView: View {
    @EnvironmentObject private var vm : CoreDataViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var hasAddNote = false
    @State private var isComplete = false
    private let isMember = KeyChainManager.read(forkey: .isNonMember) != "true"
    
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
                                CheckCellView (part: "일", point : $vm.workPoint)
                                CheckCellView (part: "건강", point : $vm.healthPoint)
                                CheckCellView (part: "가족", point : $vm.familyPoint)
                                CheckCellView (part: "관계", point : $vm.relationshipPoint)
                                CheckCellView (part: "자산", point : $vm.assetPoint)
                            }
                        }
                        else { // 완료 아닌데 노트 있음
                            VStack(spacing: 18){
                                AddNoteCellView(part: "일",symbol: "pencil", note: $vm.workNote)
                                AddNoteCellView(part: "건강",symbol: "cross.circle.fill", note : $vm.healthNote)
                                AddNoteCellView(part: "가족",symbol: "heart.fill", note: $vm.familyNote)
                                AddNoteCellView(part: "관계",symbol: "person.3.fill", note: $vm.relationshipNote)
                                AddNoteCellView(part: "자산",symbol: "dollarsign.circle.fill", note: $vm.assetNote)
                            }
                        }
                        Spacer(minLength: 102)
                        
                        Button(action: {
                            isComplete = true
                        }) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(vm.isAllSelected ? Color("DarkQ") : Color("DarkGray"))
                                .frame(width: 345, height: 66)
                                .overlay(
                                    hasAddNote ? Text("기록완료") : Text("체크완료")
                                )
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .disabled(!vm.isAllSelected)
                        
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
                        vm.updateQuintetData()
                        //MARK: - if 로그인 토크 보유 -> API 통해서 post
                        if isMember {
                            NetworkManager.shared.postCheckData(parameters: [
                                "work_deg": vm.workPoint,
                                "health_deg": vm.healthPoint,
                                "family_deg": vm.familyPoint,
                                "relationship_deg": vm.relationshipPoint,
                                "money_deg": vm.assetPoint,
                                "work_doc": vm.workNote,
                                "health_doc": vm.healthNote,
                                "family_doc": vm.familyNote,
                                "relationship_doc": vm.relationshipNote,
                                "money_doc": vm.assetNote,
                            ])
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
        .onAppear{
            vm.loadCurrentData()
//            vm.checkAllCoreData()
        }
        .modifier(CustomBackButton {
            dismiss()
        })
    }
}


struct QuintetCheckView_Previews: PreviewProvider {
    static var previews: some View {
        QuintetCheckView()
    }
}
