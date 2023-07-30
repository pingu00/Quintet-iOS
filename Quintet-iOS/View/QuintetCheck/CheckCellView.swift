//
//  CheckCellView.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/31.
//

import SwiftUI

struct CheckCellView : View {
    @State private var isCircleOn = false
    @State private var isTriangleOn = false
    @State private var isXOn = false
    
    let part : String
    @Binding var point : Int
    
    var body : some View {
        ZStack{
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.white))
                .frame(width: 345, height: 200)
            VStack{
                HStack(spacing: 0){
                    Text("오늘 하루 ")
                    Text(part)
                        .bold()
                    Text("에 얼마나 집중하셨나요?")
                }
                .font(.system(size: 18))
                .padding(.bottom)
                HStack{
                    Image(isXOn ? "XOn" : "XOff")
                        .onTapGesture {
                            isCircleOn = false
                            isTriangleOn = false
                            isXOn = true
                            point = 0
                        }
                    
                    Image(isTriangleOn ? "TriangleOn" : "TriangleOff")
                        .onTapGesture {
                            isCircleOn = false
                            isTriangleOn = true
                            isXOn = false
                            point = 1
                        }
                        .padding(.horizontal)
                    
                    Image(isCircleOn ? "CircleOn" : "CircleOff")
                        .onTapGesture {
                            isCircleOn = true
                            isTriangleOn = false
                            isXOn = false
                            point = 2
                        }
                }
                .frame(width: 70, height: 70)
            }
        }
        .onAppear {
            switch point {
            case 0 :
                isXOn = true
            case 1 :
                isTriangleOn = true
            case 2  :
                isCircleOn = true
            default:
                isCircleOn = false
                isTriangleOn = false
                isXOn = false
            }
        }
    }
}

