//
//  MenuView.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/09.
//

import SwiftUI
import StoreKit
import MessageUI
import AuthenticationServices

struct MenuView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var vm : CoreDataViewModel
    @State private var isNotiOn = false
    @State private var alarm = Date()
    @State private var showingLogoutAlert = false
    @State private var showingWithdrawAlert = false
    @State private var isShowingMailView = false
    @State private var alertNoMail = false
    @State private var withdrawText = ""
    private let isMember = KeyChainManager.read(forkey: .isNonMember) != "true"
  
    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea(.all)
            
            VStack {
                Spacer(minLength: 20)
                Group{
                    if isMember {
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
                        if isMember { // 회원 일때
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
                                        loginViewModel.action(.logout)
                                    },
                                    secondaryButton: .cancel(Text("아니오"))
                                )
                            }
                            Button(action: {
                                showingWithdrawAlert = true
                                print(showingWithdrawAlert)
                            }){
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
            
            if showingWithdrawAlert {
                ZStack {
                    Button {
                        showingWithdrawAlert = false
                    } label: {
                        ZStack {
                            Color(.black)
                                .opacity(0.5)
                        }
                    }
                    .ignoresSafeArea()
                    
                    ZStack {
                        Color(.background)
                        VStack {
                            HStack {
                                Spacer()
                                Image(.quintetLogo)
                                    .padding(.horizontal, 20)
                                Spacer()
                            }
                            .padding(.vertical, 20)
                            
                            Text("정말 탈퇴하시겠습니까?")
                                .font(.system(size: 17, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                            Text("아래 '확인했습니다'를 입력해주세요.")
                                .font(.system(size: 15, weight: .regular))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                            TextField("확인했습니다", text: $withdrawText)
                                .padding(.horizontal, 20)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            if let socialProvider = KeyChainManager.read(forkey: .socialProvider) {
                                switch socialProvider {
                                case SocialProvider.APPLE.rawValue:
                                    SignInWithAppleButton(.continue) { request in
                                        request.requestedScopes = [.fullName, .email]
                                    } onCompletion: { result in
                                        switch result {
                                        case .success(let authResults):
                                            if
                                                let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential,
                                                let authorizationCode = appleIDCredential.authorizationCode
                                            {
                                                let code = String(decoding: authorizationCode, as: UTF8.self)
                                                loginViewModel.action(.withdrawApple(code: code))
                                            }
                                        case .failure(let error):
                                            print("Auth Fail: \(error.localizedDescription)")
                                        }
                                    }
                                    .frame(height: 44)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 20)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .disabled(withdrawText != "확인했습니다")
                                default:
                                    Button {
                                        if socialProvider == SocialProvider.GOOGLE.rawValue {
                                            loginViewModel.action(.withdrawGoogle)
                                            showingWithdrawAlert = false
                                        } else {
                                            loginViewModel.action(.withdrawGoogle)
                                            showingWithdrawAlert = false
                                        }
                                    } label: {
                                        ZStack {
                                            Color(.red)
                                            Text("탈퇴하기")
                                        }
                                    }
                                    .tint(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .frame(height: 44)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 20)
                                    .disabled(withdrawText != "확인했습니다")
                                }
                            }
                            
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .padding(.horizontal, 60)
                    .padding(.vertical, 200)
                }
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
