//
//  EditProfileView.swift
//  Cleset
//
//  Created by 엄태양 on 4/29/24.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditProfileViewModel
    @State var nickname: String = UserManager.getUserData()?.nickname ?? ""
    @State var gender: Gender = UserManager.getUserData()?.gender ?? .male
    @State var age: Int = UserManager.getUserData()?.age ?? 0
    
    var body: some View {
        VStack {
            NavigationHeader(button: editProfileRightBarButton)
            
            ScrollView {
                VStack(alignment: .leading) {
                    nicknameInput
                    genderInput
                    ageInput
                }.padding(.horizontal, 20)
            }
        }
        .navigationBarBackButtonHidden()
        .alert(isPresented: $viewModel.presentingAlert, content: {
            Alert(
                title: Text(viewModel.alertData?.title ?? ""),
                message: Text(viewModel.alertData?.description ?? ""),
                dismissButton: .default(Text("확인"), action: {
                    if let alert = viewModel.alertData,
                       alert.dismiss {
                        dismiss()
                    }
                })
            )
        })
    }
    
    var editProfileRightBarButton: some View {
        Button {
            viewModel.send(.updateButtonTap(nickname: nickname, gender: gender, age: age))
        } label: {
            Text("저장")
        }
    }
    
    var nicknameInput: some View {
        VStack(alignment: .leading) {
            Text("닉네임")
            HStack {
                VStack(spacing: 2) {
                    if #available(iOS 17.0, *) {
                        TextField(text: $nickname) {
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                        .onChange(of: nickname) {
                            viewModel.send(.nicknameChanged($1))
                        }
                    } else {
                        TextField(text: $nickname) {
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                        .onChange(of: nickname, perform: { value in
                            viewModel.send(.nicknameChanged(value))
                        })
                    }
                    
                    Rectangle()
                        .fill(Color.gray0)
                        .frame(height: 1)
                }
                
                
                Button {
                    viewModel.send(.nicknameCheckButtonTap(nickname))
                } label: {
                    Text("중복확인")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .padding(10)
                        .background(Color.mainGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
        }
    }
    
    var genderInput: some View {
        Group {
            Text("성별")
                .padding(.top, 30)
                .padding(.bottom, -20)
            
            Picker("성별을 골라주세요", selection: $gender) {
                ForEach(Gender.allCases, id:\.self) { gender in
                    Text(gender.rawValue)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 80)
        }
    }
    
    var ageInput: some View {
        Group {
            Text("나이")
            
            VStack(spacing: 2) {
                HStack {
                    TextField(value: $age, formatter: NumberFormatter()) {
                        
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 30)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    Text("세")
                }
                
                Rectangle()
                    .fill(Color.gray0)
                    .frame(height: 1)
            }
        }
    }
}

#Preview {
    EditProfileView(viewModel: EditProfileViewModel(container: .stub))
}
