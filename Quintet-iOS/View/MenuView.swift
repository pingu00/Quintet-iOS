//
//  MenuView.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isNotiOn = false
    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea(.all)
            List {
                Section {
                    Button(action: {}){
                        HStack{
                            Text("시간대 설정")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("DarkGray"))
                        }
                    }
                    Toggle("알림", isOn: $isNotiOn)
                        .toggleStyle(SwitchToggleStyle(tint: Color("DarkQ")))
                } header: {
                    Text("알림설정")
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .padding(.bottom,9)
                }
                Section {
                    Button(action: {}){
                        HStack{
                            Text("기존 데이터 불러오기 / 내보내기")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("DarkGray"))
                        }
                    }
                    Button(action: {}){
                        HStack{
                            Text("데이터 초기화")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("DarkGray"))
                        }
                    }
                } header: {
                    Text("데이터")
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .padding(.bottom,9)
                }
                Section {
                    Button(action: {}){
                        HStack{
                            Text("리뷰 남기러 가기")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("DarkGray"))
                        }
                    }
                    Button(action: {}){
                        HStack{
                            Text("문의하기")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("DarkGray"))
                        }
                    }
                    Button(action: {}){
                        HStack{
                            Text("업데이트 소식")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("DarkGray"))
                        }
                    }
                    Button(action: {}){
                        HStack{
                            Text("이용 약관")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("DarkGray"))
                        }
                    }
                }
                Section {
                    Button(action: {}){
                        HStack{
                            Text("로그아웃")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("DarkGray"))
                        }
                    }
                    Button(action: {}){
                        HStack{
                            Text("계정 탈퇴")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("DarkGray"))
                        }
                    }
                } header: {
                    Text("계정")
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .padding(.bottom,9)
                }
                
            }
            .font(.system(size: 16))
            .environment(\.defaultMinListRowHeight, 58)
            .foregroundColor(.black)
            .background(Color("Background"))
            .scrollContentBackground(.hidden)
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
    }     
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
