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
    @StateObject var vm = CoreDataViewModel()
    @State private var alarm = Date()
    @State private var hasLogin = false
    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea(.all)
            VStack {
                Spacer(minLength: 20)
                Group{
                    if hasLogin {
                        Text(vm.userName)
                            .fontWeight(.bold)
                        + Text("님")
                        Text("안녕하세요!")
                    }
                    else {
                        Text("로그인 \n 해주세요!")
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                    }
                }
                .font(.system(size: 24))
                Form {
                    Section {
                        if hasLogin { // 회원 일때
                            Button(action: {}){
                                HStack{
                                    Text("프로필 편집")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color("DarkGray"))
                                }
                            }
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
                        }
                        else { // 비회원 일때
                            Button(action: {print("로그인 화면으로 이동")}){
                                HStack{
                                    Text("로그인")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color("DarkGray"))
                                }
                            }
                        }
                    } header: {
                        Text("계정")
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .padding(.bottom,9)
                    }
                    Section {
                        Toggle("알림", isOn: $isNotiOn)
                            .toggleStyle(SwitchToggleStyle(tint: Color("DarkQ")))
                        DatePicker( "시간대 설정", selection: $alarm,
                                    displayedComponents: .hourAndMinute)
                        .environment(\.locale, Locale(identifier: "ko_KR"))
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
                                Text("이용 약관")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("DarkGray"))
                            }
                        }
                    }
                    
                    
                }
                .font(.system(size: 16))
                .environment(\.defaultMinListRowHeight, 58)
                .foregroundColor(.black)
                .background(Color("Background"))
            .scrollContentBackground(.hidden)
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
    }     
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
