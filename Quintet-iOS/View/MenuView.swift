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
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm = CoreDataViewModel()
    @State private var isNotiOn = false
    @State private var alarm = Date()
    @State private var showingLogoutAlert = false
    @State private var isShowingMailView = false
        @State private var alertNoMail = false
    private let hasLogin = KeyChainManager.hasKeychain(forkey: .accessToken)
  
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

struct ProfileEditView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var nameText : String
    let vm : CoreDataViewModel
    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea(.all)
            VStack(spacing: 5){
                HStack{
                    Text("이름")
                        .font(.system(size: 18, weight: .medium))
                        .padding(.horizontal)
                    Spacer()
                    VStack{
                        Text("\(nameText.count)/10자")
                            .font(.system(size: 16))
                            .padding(.top)
                            .padding(.top)
                    }
                }
                TextField(vm.userName, text: $nameText)
                    .padding()
                    .background(.white)
                    .cornerRadius(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color("LightGray2"))
                        )
                Spacer()
                Button(action: {
                    vm.saveUserName(name: nameText)
                    dismiss()
                }){
                    RoundedRectangle(cornerRadius: 20)
                        .fill(canSaveName() ?
                              Color("DarkQ") : Color("DarkGray") )
                        .frame(width: 345, height: 66)
                        .overlay(
                            Text("저장")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        )
                }
                .disabled(!canSaveName())
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack{
                        Button (action:{dismiss()}){
                            Image(systemName: "chevron.backward")
                                .bold()
                                .foregroundColor(Color(.black))
                        }
                        Spacer(minLength: 20)
                        Text("프로필 편집")
                    }
                }
            }
        }
        .onTapGesture {
            dismissKeyboard()
        }
    }
    private func canSaveName () -> Bool {
        return nameText.count <= 10 && nameText.count != 0
    }
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
struct MailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool

        init(isShowing: Binding<Bool>) {
            _isShowing = isShowing
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            isShowing = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = context.coordinator
        mailVC.setToRecipients(["rlavlfrb0119@gmail.com"]) // 개발자 이메일 주소 설정
        mailVC.setSubject("문의하기") // 이메일 제목 설정
        mailVC.setMessageBody("", isHTML: false) // 이메일 본문 설정
        return mailVC
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
