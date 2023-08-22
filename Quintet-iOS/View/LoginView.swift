//
//  LoginView.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/08/03.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Moya

struct LoginView: View {
    @State private var isLoading = true
    
    var body: some View {
        NavigationView{
            
            ZStack{
                
                Color("Background").ignoresSafeArea(.all).transition(.opacity)
                if isLoading {
                    Image("QuintetLogo")
                        .transition(.opacity)
                }
                else {
                    VStack{
                        Spacer()
                        Image("Quintet_main")
                        
                        Spacer()
                        
                        //MARK: 회원 로그인 버튼 모음
                        VStack{
                            Button {
                                print("kakao loginBtn Tapped")
                            } label: {
                                Image("Kakao_login")
                            }
                            
                            Button {
                                print("apple loginBtn Tapped")
                            } label: {
                                Image("Apple_login")
                            }
                            
                            Button {
                                print("google loginBtn Tapped")
                                handleSignInButton()
                                
                            } label: {
                                Image("Google_login")
                            }
                        }.padding(.vertical, 30)
                        
                        //MARK: 비회원 로그인 버튼
                        NavigationLink(destination: {
                            HomeView()
                        }){
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("DarkGray"))
                                    .frame(width: 345, height: 52)
                                    .overlay(Text("비회원으로 로그인 하기")
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                    )
                            }
                        }.padding(.bottom, 20)
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                withAnimation{
                    isLoading.toggle()
                }
            })
        }
    }
    
    
    func handleSignInButton() {
                guard let presentingViewController = (UIApplication.shared.connectedScenes.first
                                                      as? UIWindowScene)?.windows.first?.rootViewController
                else {return}
                let serverClientID = "57072604372-mp0psmdo18mme37oan2u72aff4iqeqod.apps.googleusercontent.com"
                let clientID = "57072604372-atronfd68sgo0l369sd215l4veu05rtb.apps.googleusercontent.com"
        
                GIDSignIn.sharedInstance.configuration = .init(clientID: clientID, serverClientID: serverClientID)
                GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController){ signInResult, err in
                    if let error = err{
                        print("google login 실패 \(error.localizedDescription)")
                        return
                    }
                    

                    let provider = MoyaProvider<LoginAPI>()
                    
                    provider.request(.getCallBack) { result in
                        switch result{
                        case .success(let data):
                            print(data)
                        case .failure(let error):
                            print("로그인은 성공했으나, call API error:\(error)")
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
