//
//  File.swift
//  Quintet-iOS
//
//  Created by yeongjoon on 5/16/24.
//

import SwiftUI

struct OnboardingTermsView: View {
    var onAgree: () -> Void
    @State private var isAgree = false
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("서비스 이용약관")
                        .font(Font.system(size: 18).bold())
                        .foregroundStyle(.black)
                    Button(action: {
                        isAgree.toggle()
                    }, label: {
                        HStack {
                            if isAgree {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color("DarkQ"))
                            }
                            else {
                                Image(systemName: "circle")
                                    .foregroundStyle(.black)
                            }
                            Text("동의하기")
                                .font(Font.system(size: 16))
                                .foregroundStyle(.black)
                        }
                    })
                }
                .padding(.leading, 20)
                Spacer()
            }
            .padding(.top, 20)
            
            Rectangle()
                .foregroundStyle(Color("DarkGray"))
                .frame(width: 360, height: 0.7)
            ScrollView {
                TermsView()
            }
            Button(action: {
                onAgree()
            }, label: {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 320, height: 60)
                    .foregroundStyle(isAgree ? Color("DarkQ") : Color("DarkGray"))
                    .overlay(
                        Text("시작하기")
                            .font(Font.system(size: 20))
                            .foregroundStyle(.white)
                    )
                    
            })
            .disabled(!isAgree)
            
        }
    }
}



#Preview {
    OnboardingTermsView(onAgree: {})
}
