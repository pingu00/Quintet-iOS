//
//  LoginView.swift
//  Quintet-iOS
//
//  Created by 이동현 on 2023/08/03.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea(.all)
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
                    } label: {
                        Image("Google_login")
                    }
                }.padding(.vertical, 30)
                
                //MARK: 비회원 로그인 버튼
                Button {
                    print("non_member loginBtn Tapped")
                } label: {
                    Image("Non_member_login")
                }.padding(.bottom, 20)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
