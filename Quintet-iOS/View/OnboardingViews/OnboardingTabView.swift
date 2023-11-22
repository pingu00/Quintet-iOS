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
        }
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .clear
            UIPageControl.appearance().pageIndicatorTintColor = .clear
        }
    }
}

