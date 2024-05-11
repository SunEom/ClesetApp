//
//  WritePostView.swift
//  Cleset
//
//  Created by 엄태양 on 5/9/24.
//

import SwiftUI
import PhotosUI

struct WritePostView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: WritePostViewModel
    @State var title: String = ""
    @State var postBody: String = ""
    @State var boardType: BoardType = .fashion
    @State var selectedImage: PhotosPickerItem? = nil
    @State var imagePreview: Image? = nil
    
    var body: some View {
        VStack {
            NavigationHeader(button: Button {
                viewModel.send(.saveButtonTap(title: title, boardType: boardType, postBody: postBody))
            } label: {
                Text("저장")
            }.buttonStyle(PlainButtonStyle()))
            
            VStack {
                TextField("제목", text: $title)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Rectangle()
                    .fill(Color.gray0)
                    .frame(height: 1)
            }
            
            Picker("게시판 종류", selection: $boardType) {
                ForEach(BoardType.allCases) { Text($0.displayName) }
            }
            .pickerStyle(.menu)
            .frame(width: UIScreen.main.bounds.width)
            .accentColor(.black)
            
            
            ZStack {
                
                TextEditor(text: $postBody)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .background(RoundedRectangle(cornerRadius:10).stroke(Color.gray0, lineWidth: 1))
                
                if postBody == "" {
                    VStack {
                        HStack {
                            Text("내용을 입력해주세요")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.gray0)
                                .padding(7)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                }
            }
            
            HStack {
                if let selectedImagePreview = viewModel.selectedImagePreview {
                    Button {
                        viewModel.send(.imageDisselected)
                    } label: {
                        selectedImagePreview
                            .resizable()
                            .frame(width: 45, height: 45)
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray0, lineWidth: 1))
                    }
                } else {
                    Image("photo")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 45, height: 45)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray0, lineWidth: 1))
                }
                
                Spacer()
                
                PhotosPicker(
                    selection: $selectedImage,
                    matching: .images
                ) {
                    Group {
                        Image(systemName: "camera")
                        Text("이미지 선택하기")
                    }
                    .foregroundStyle(Color.black)
                }
                .padding(.horizontal, 10)
            }
            .padding(.vertical, 10)
            
        }
        .padding(.horizontal, 20)
        .navigationBarBackButtonHidden()
        .onChange(of: selectedImage) { _ in
            viewModel.send(.imageSelected(selectedImage))
        }
        .alert(isPresented: Binding(get: {
            viewModel.alertData != nil
        }, set: { _ in}), content: {
            Alert(
                title: Text(viewModel.alertData!.title),
                message: Text(viewModel.alertData!.description),
                dismissButton: .default(Text("확인")) {
                    guard let alertData = viewModel.alertData else { return }
                    
                    viewModel.send(.alertDismiss)
                    
                    if alertData.result {
                        dismiss()
                    }
                }
            )

        })
        .onAppear {
            boardType = viewModel.boardType
            
            if let postData = viewModel.postData {
                title = postData.title
                postBody = postData.postBody
                boardType = postData.boardType
            }
        }
    }
}


#Preview {
    WritePostView(viewModel: WritePostViewModel(container: .stub, boardType: .tip, postData: .stubList[0]))
}
