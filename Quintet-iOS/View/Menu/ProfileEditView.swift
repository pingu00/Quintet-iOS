//
//  ProfileEditView.swift
//  Quintet-iOS
//
//  Created by Phil on 2/22/24.
//

import SwiftUI

struct ProfileEditView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var nameText : String
    let vm : CoreDataViewModel
    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea(.all)
            VStack(spacing: 5){
                HStack{
                    Text("이름")
                        .font(.system(size: 18, weight: .medium))
                        .padding(.horizontal)
                    Spacer()
                    VStack{
                        Text("\(nameText.count)/10자")
                            .font(.system(size: 16))
                            .padding(.top)
                            .padding(.top)
                    }
                }
                TextField(vm.userName, text: $nameText)
                    .padding()
                    .background(.white)
                    .cornerRadius(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color("LightGray2"))
                        )
                Spacer()
                Button(action: {
                    vm.saveUserName(name: nameText)
                    dismiss()
                }){
                    RoundedRectangle(cornerRadius: 20)
                        .fill(canSaveName() ?
                              Color("DarkQ") : Color("DarkGray") )
                        .frame(width: 345, height: 66)
                        .overlay(
                            Text("저장")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        )
                }
                .disabled(!canSaveName())
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack{
                        Button (action:{dismiss()}){
                            Image(systemName: "chevron.backward")
                                .bold()
                                .foregroundColor(Color(.black))
                        }
                        Spacer(minLength: 20)
                        Text("프로필 편집")
                    }
                }
            }
        }
        .onTapGesture {
            dismissKeyboard()
        }
    }
    private func canSaveName () -> Bool {
        return nameText.count <= 10 && nameText.count != 0
    }
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
