//
//  QuintetCheckView.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI

struct QuintetCheckView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var hasAddNote = false
    @State private var isComplete = false
    
    @State private var workPoint = 0
    @State private var healthPoint = 0
    @State private var familyPoint = 0
    @State private var relationshipPoint = 0
    @State private var assetPoint = 0
    
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
                        
                        Button(action: { isComplete = true }){
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("DarkQ"))
                                .frame(width: 345, height: 66)
                                .overlay(
                                    hasAddNote ? Text("기록완료") : Text("체크완료")
                                    
                                )
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
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
                    Button(action: { print("HomeView로 이동 + point 정보와 note 정보가 오늘의 퀸텟 모델 형태로 서버로 전공")}){
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
}

struct CheckCellView : View {
    @State private var isCircleOn = false
    @State private var isTriangleOn = false
    @State private var isXOn = false
    
    let part : String
    @Binding var point : Int
    
    var body : some View {
        ZStack{
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.white))
                .frame(width: 345, height: 200)
            VStack{
                HStack(spacing: 0){
                    Text("오늘 하루 ")
                    Text(part)
                        .bold()
                    Text("에 얼마나 집중하셨나요?")
                }
                .font(.system(size: 18))
                .padding(.bottom)
                HStack{
                    Image(isXOn ? "XOn" : "XOff")
                        .onTapGesture {
                            isCircleOn = false
                            isTriangleOn = false
                            isXOn = true
                            point = 0
                        }
                    
                    Image(isTriangleOn ? "TriangleOn" : "TriangleOff")
                        .onTapGesture {
                            isCircleOn = false
                            isTriangleOn = true
                            isXOn = false
                            point = 1
                        }
                        .padding(.horizontal)
                    
                    Image(isCircleOn ? "CircleOn" : "CircleOff")
                        .onTapGesture {
                            isCircleOn = true
                            isTriangleOn = false
                            isXOn = false
                            point = 2
                        }
                }
                .frame(width: 70, height: 70)
            }
        }
    }
}

struct AddNoteCellView : View{
    let part : String
    let symbol : String
    @Binding var note : String
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.white))
                .frame(width: 345, height: 200)
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: symbol)
                    Text (part)
                        .font(.system(size:20))
                }.padding(.horizontal)
                TextField("오늘의 \(part) 기록을 작성해보세요", text: $note)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .padding(.bottom)
                    .padding(.bottom)
                    .padding(.bottom)
                    .padding(.horizontal)
                    .frame(width: 310, height: 110)
                    .background(Color("Background"))
                    .cornerRadius(20)
            }
        }
    }
}


struct QuintetCheckView_Previews: PreviewProvider {
    static var previews: some View {
        QuintetCheckView()
    }
}
