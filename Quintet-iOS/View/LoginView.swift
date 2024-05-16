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
    @State private var isKakaoTermsPresent = false
    @State private var isAppleTermsPresent = false
    @State private var isAppleAgree = false
    @State private var isGoogleTermsPresent = false
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    var body: some View {
            ZStack{
                Color("Background").ignoresSafeArea(.all).transition(.opacity)
                VStack{
                    Spacer()
                    Image("Quintet_main")
                    
                    Spacer()
                    
                    //MARK: 회원 로그인 버튼 모음
                    VStack{
                        Button(action: {
                            isAppleTermsPresent = true
                        }, label: {
                            Text("이용약관 동의하기")
                        })
                        .sheet(isPresented: $isAppleTermsPresent, content: {
                            OnboardingTermsView(onAgree: {
                                isAppleTermsPresent = false
                                isAppleAgree = true
                            })
                        })
                        
                        Button {
                            isKakaoTermsPresent = true
                            print("카카오 로그인 버튼 눌림")
//                            loginViewModel.kakaoSignIn()
                        } label: {
                            HStack {
                                Image("KakaoLogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                        
                                Text("Continue with Kakao")
                                    .font(.system(size: 19, weight: .regular))
                                    .foregroundColor(.black)
                            }
                        }
                        .sheet(isPresented: $isKakaoTermsPresent, content: {
                            OnboardingTermsView(onAgree: {
                                isKakaoTermsPresent = false
                                DispatchQueue.main.async {
                                    loginViewModel.kakaoSignIn()
                                }
                            })
                        })
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color(.kakao))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        SignInWithAppleButton(.continue) { request in
                            request.requestedScopes = [.fullName, .email]
                        } onCompletion: { result in
                            switch result {
                            case .success(let authResults):
                                if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                                    loginViewModel.appleSignIn(appleIDCredential)
                                }
                            case .failure(let error):
                                print("Auth Fail: \(error.localizedDescription)")
                            }
                        }
                        .frame(height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .disabled(!isAppleAgree)
                        
                        Button {
                            isGoogleTermsPresent = true
                            print("google loginBtn Tapped")
//                            loginViewModel.googleSignIn()
                            
                        } label: {
                            HStack {
                                Image("GoogleLogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                                Text("Continue with Google")
                                    .font(.system(size: 19, weight: .regular))
                                    .foregroundColor(.black)
                            }
                        }
                        .sheet(isPresented: $isGoogleTermsPresent, content: {
                            OnboardingTermsView(onAgree: {
                                isGoogleTermsPresent = false
                                DispatchQueue.main.async {
                                    loginViewModel.googleSignIn()
                                }
                            })
                        })
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color(.white))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 48)
                    
                    //MARK: 비회원 로그인 버튼
                    Button(action: {
                        KeyChainManager.save(forKey: .isNonMember, value: "true")
                        loginViewModel.updateHasKeychain(state: true)
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
