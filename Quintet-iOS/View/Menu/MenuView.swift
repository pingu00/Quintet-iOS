//
//  MenuView.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI
import StoreKit
import MessageUI

struct MenuView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var vm : CoreDataViewModel
    @State private var isNotiOn = false
    @State private var alarm = Date()
    @State private var showingLogoutAlert = false
    @State private var isShowingMailView = false
        @State private var alertNoMail = false
    private let isMember = KeyChainManager.read(forkey: .isNonMember) != "true"
  
    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea(.all)
            
            VStack {
                Spacer(minLength: 20)
                Group{
                    if !isMember {
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
                        if !isMember { // 회원 일때
                            HStack{
                                Text("프로필 편집")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("DarkGray"))
                            }.overlay(
                                NavigationLink(destination:{ProfileEditView(nameText: vm.userName, vm : vm)})
                                {EmptyView()}
                            )
                            Button(action: {
                                showingLogoutAlert = true
                            }){
                                HStack{
                                    Text("로그아웃")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color("DarkGray"))
                                }
                            }.alert(isPresented: $showingLogoutAlert){
                                Alert(
                                    title: Text("로그아웃"),
                                    message: Text("정말 로그아웃 하시겠습니까?"),
                                    primaryButton: .destructive(Text("네")) {
                                        KeyChainManager.removeAllKeychain()
                                        loginViewModel.updateHasKeychain(state: false)
                                    },
                                    secondaryButton: .cancel(Text("아니오"))
                                )
                                
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
                            Button(action: {
                                print("로그인 버튼 Tapped")
                                KeyChainManager.removeAllKeychain()
                                loginViewModel.updateHasKeychain(state: false)
                                
                            }){
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
                    //MARK: - 알림
//                    Section {
//                        Toggle("알림", isOn: $isNotiOn)
//                            .toggleStyle(SwitchToggleStyle(tint: Color("DarkQ")))
//                        DatePicker( "시간대 설정", selection: $alarm,
//                                    displayedComponents: .hourAndMinute)
//                        .environment(\.locale, Locale(identifier: "ko_KR"))
//                    } header: {
//                        Text("알림설정")
//                            .foregroundColor(.black)
//                            .font(.system(size: 18))
//                            .fontWeight(.medium)
//                            .padding(.bottom,9)
//                    }
                    
                    Section {
                        Button(action: {
                            SKStoreReviewController.requestReview()
                        }){
                            HStack{
                                Text("리뷰 남기러 가기")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("DarkGray"))
                            }
                        }
                        Button(action: {
                            if MFMailComposeViewController.canSendMail() {
                                self.isShowingMailView = true
                            } else {
                                self.alertNoMail = true
                            }
                        }) {
                            HStack{
                                Text("문의하기")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("DarkGray"))
                            }
                        }
                        .sheet(isPresented: $isShowingMailView) {
                                    MailView(isShowing: self.$isShowingMailView)
                                        .edgesIgnoringSafeArea(.all)
                                }
                                .alert(isPresented: $alertNoMail) {
                                    Alert(title: Text("오류"), message: Text("이메일을 보낼 수 없습니다. 메일 앱을 확인하세요."), dismissButton: .default(Text("확인")))
                                }
                            HStack{
                                Text("이용 약관")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("DarkGray"))
                            }.overlay{ NavigationLink(destination: {TermsView()}){
                                EmptyView()}
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
        .onAppear {
            vm.loadUserName()
        }
        .modifier(CustomBackButton {
                    dismiss()
                })
    }
}




struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
