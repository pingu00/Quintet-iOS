//
//  LoginView.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/08/03.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var isLoading = true
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    var body: some View {
        NavigationView{
            ZStack{
                Color("Background").ignoresSafeArea(.all).transition(.opacity)
                VStack{
                    Spacer()
                    Image("Quintet_main")
                    
                    Spacer()
                    
                    //MARK: 회원 로그인 버튼 모음
                    VStack{
                        Button {
                            print("카카오 로그인 버튼 눌림")
                        } label: {
                            HStack {
                                Image("KakaoLogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                Text("카카오로 계속하기")
                                    .font(.system(size: 28, weight: .medium))
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 66)
                        .background(Color(.kakao))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.bottom, 10)
                        
                        SignInWithAppleButton(.continue) { request in
                            request.requestedScopes = [.fullName, .email]
                        } onCompletion: { result in
                            switch result {
                            case .success(let authResults):
                                print("Auth Success: \(authResults)")
                            case .failure(let error):
                                print("Auth Fail: \(error.localizedDescription)")
                            }
                        }
                        .frame(height: 66)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.bottom, 10)
                        
                        Button {
                            print("google loginBtn Tapped")
                            loginViewModel.googleSignIn()
                            
                        } label: {
                            HStack {
                                Image("GoogleLogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                Text("Google로 계속하기")
                                    .font(.system(size: 28, weight: .medium))
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 66)
                        .background(Color(.white))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 48)
                    
                    //MARK: 비회원 로그인 버튼
                    NavigationLink(destination: {
                        HomeView()
                    }){
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("DarkGray"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .overlay(Text("비회원으로 로그인 하기")
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
                
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
