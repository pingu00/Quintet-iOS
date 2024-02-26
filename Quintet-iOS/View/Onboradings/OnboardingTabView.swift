//
//  OnboardingTabView.swift
//  Quintet-iOS
//
//  Created by 김영준 on 11/22/23.
//

import SwiftUI

struct OnboardingTabView: View {
    @Binding var isFirstLaunching: Bool
    var body: some View {
        TabView {
            OnboardingPageView(
                imageName: "Onboarding1"
            )
            OnboardingPageView(
                imageName: "Onboarding2"
            )
            OnboardingPageView(
                imageName: "Onboarding3"
            )
            OnboardingPageView(
                imageName: "Onboarding4"
            )
            
            VStack {
                Text("환영합니다!")
                    .fontWeight(.bold)
                    .font(.system(size: 34))
                    .multilineTextAlignment(.center)
                    .padding(.top, 150)
                Text("지금 바로 퀸텟과 함께 \n행복한 삶을 운영해보세요!")
                    .fontWeight(.medium)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.61, green: 0.61, blue: 0.61))
                    .padding(.top, 5)
                Image("QuintetLogo")
                    .resizable()
                    .frame(width: 116, height: 71)
                    .padding(.top, 50)
                Spacer()
                
                Button(action: {
                    isFirstLaunching = false
                }, label: {
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(Color(red: 0.36, green: 0.38, blue: 1))
                        .frame(width: 345, height: 64)
                        .overlay(
                            Text("시작하기")
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                                .foregroundStyle(.white)
                        )
                })
                .padding(.bottom, 50)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .clear
            UIPageControl.appearance().pageIndicatorTintColor = .clear
        }
    }
}
