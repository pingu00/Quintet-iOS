//
//  AddNoteCellView.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/07/31.
//

import SwiftUI

struct AddNoteCellView : View{
    let part : String
    let symbol : String
    @Binding var note : String
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.white))
                .frame(width: 345, height: 200)
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: symbol)
                    Text (part)
                        .font(.system(size:20))
                }.padding(.horizontal)
                TextField("오늘의 \(part) 기록을 작성해보세요", text: $note)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .padding(.bottom)
                    .padding(.bottom)
                    .padding(.bottom)
                    .padding(.horizontal)
                    .frame(width: 310, height: 110)
                    .background(Color("Background"))
                    .cornerRadius(20)
            }
        }
    }
}

