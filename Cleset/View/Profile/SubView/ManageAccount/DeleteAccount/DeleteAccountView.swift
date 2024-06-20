//
//  DeleteAccountView.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import SwiftUI

struct DeleteAccountView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: DeleteAccountViewModel
    var body: some View {
        VStack {
            NavigationHeader<AnyView>(title: "회원탈퇴")
            
            VStack {
                Text("Cleset을 탈퇴하시겠어요?")
                    .font(.system(size: 20, weight: .semibold))
                
                VStack(spacing: 15) {
                    Text("탈퇴하시기 전 다시 한번 확인해주세요.")
                        .font(.system(size: 14, weight: .semibold))
                    
                    VStack {
                        HStack {
                            Image("dot")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(Color.background)
                                .frame(width: 8, height: 8)
                            
                            Text("한번 삭제된 계정은 더이상 복구할 수 없습니다.")
                                .font(.system(size: 12))
                            Spacer()
                        }
                        
                        HStack {
                            Image("dot")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(Color.background)
                                .frame(width: 8, height: 8)
                            
                            Text("삭제된 계정의 게시글 및 댓글은 모두 삭제됩니다.")
                                .font(.system(size: 12))
                            Spacer()
                        }
                        
                        HStack {
                            Image("dot")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(Color.background)
                                .frame(width: 8, height: 8)
                            
                            Text("그동안 \"똑똑한 나만의 옷장\" Cleset을 이용해주셔서 감사합니다.")
                                .font(.system(size: 12))
                            Spacer()
                        }
                        
                    }
                    .padding(.horizontal, 30)
                    
                }
                .padding(.vertical, 20)
                .background(Color.gray0)
            }
            .padding(.top, 30)
            
            HStack(spacing: 30) {
                Button {
                    viewModel.send(.deleteButtonTap)
                } label: {
                    Text("회원 탈퇴하기")
                        .foregroundStyle(Color.mainGreen)
                        .font(.system(size: 16, weight: .bold))
                }
                .frame(width: 120, height: 50)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.mainGreen, lineWidth: 2)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button {
                    dismiss()
                } label: {
                    Text("계속 이용하기")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 16, weight: .bold))
                }
                .frame(width: 120, height: 50)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.mainGreen)
                }
                .buttonStyle(PlainButtonStyle())
                
            }
            .padding(.top, 15)
            
            Spacer()
        }
        .background(Color.background)
        .navigationBarBackButtonHidden()
        .alert(isPresented: $viewModel.presentingAlert, content: {
            Alert(
                title: Text("알림"),
                message: Text("그 동안 이용해주셔서 감사합니다."),
                dismissButton: .default(Text("확인"), action: {
                    authViewModel.send(.logout)
                })
                
            )
        })

    }
}

#Preview {
    DeleteAccountView(viewModel: DeleteAccountViewModel(container: .stub))
}
