//
//  SignUpView.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: SignUpViewModel
    @State var nickname: String = ""
    @State var gender: Gender = .male
    @State var age: Int = 0
    
    var body: some View {
        VStack {
            NavigationHeader(
                button: Button("저장") {
                    viewModel.send(.signUpButtonTap(nickname: nickname, gender: gender, age: age))
                }.buttonStyle(PlainButtonStyle()),
                title: "회원가입"
            )
            
            Group {
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
                                    viewModel.send(.nicknameChanged(nickname))
                                }
                            } else {
                                TextField(text: $nickname) {
                                }
                                .padding(.horizontal, 10)
                                .frame(height: 30)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                .onChange(of: nickname, perform: { _ in
                                    viewModel.send(.nicknameChanged(nickname))
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
                .padding(.top, 30)
                
                VStack(alignment: .leading) {
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
                
                VStack(alignment: .leading) {
                    Text("나이")
                    
                    VStack(spacing: 2) {
                        HStack {
                            TextField(value: $age, formatter: NumberFormatter()) {
                                Text("나이를 입력해주세요")
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
            .padding(.horizontal, 20)
            
            
            Spacer()
        }
        .background(Color.background)
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
    
}

#Preview {
    SignUpView(viewModel: SignUpViewModel(container: .stub))
}
