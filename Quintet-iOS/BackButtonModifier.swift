//
//  BackButtonModifier.swift
//  Quintet-iOS
//
//  Created by Phil on 1/24/24.
//

import Foundation
import SwiftUI

struct CustomBackButton: ViewModifier {
    var action: () -> Void

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: action) {
                        Image(systemName: "chevron.backward")
                            .bold()
                            .foregroundColor(Color(.black))
                    }
                }
            }
            .gesture(DragGesture().onEnded { gesture in
                // 스와이프 제스처가 완료되면 뒤로가기 수행
                if gesture.translation.width > 100 {
                    action()
                }
            })
    }
}
