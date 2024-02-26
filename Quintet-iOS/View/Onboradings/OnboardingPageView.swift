//
//  OnboardingPageView.swift
//  Quintet-iOS
//
//  Created by 김영준 on 11/22/23.
//

import SwiftUI

struct OnboardingPageView: View {
    let imageName: String
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    OnboardingPageView(imageName: "Onboarding1")
}
