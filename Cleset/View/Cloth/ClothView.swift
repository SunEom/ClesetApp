//
//  ClothView.swift
//  Cleset
//
//  Created by 엄태양 on 5/13/24.
//

import SwiftUI
import PhotosUI

struct ClothView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ClothViewModel
    @State var selectedImage: PhotosPickerItem? = nil
    @State var name: String = ""
    @State var category: Category = .shirt
    @State var brand: String = ""
    @State var size: String = ""
    @State var place: String = ""
    @State var spring: Bool = false
    @State var summer: Bool = false
    @State var fall: Bool = false
    @State var winter: Bool = false
    @State var memo: String = ""
    
    var selectedSeasons: [Season] {
        get {
            var list = [Season]()
            
            if spring {
                list.append(.spring)
            }
            
            if summer {
                list.append(.summer)
            }
            
            if fall {
                list.append(.fall)
            }
            
            if winter {
                list.append(.winter)
            }
            
            return list
        }
    }
    
    var body: some View {
        VStack {
            NavigationHeader(
                button: Button {
                    viewModel.send(
                        .saveButtonTap(
                            name: name,
                            category: category,
                            brand: brand,
                            size: size,
                            place: place,
                            season: selectedSeasons,
                            memo: memo
                        )
                    )
                } label: {
                    Text("저장")
                },
                title: viewModel.mode == .create ? "의상 추가" : "의상 수정"
            )
            
            ScrollView {
                imageInputView
                    .padding(.bottom, 20)
                
                VStack(spacing: 20) {
                    InputView(title: "제품명", placeholder: "제품명을 입력해주세요.", input: $name)
                    categoryInputView
                    InputView(title: "브랜드", placeholder: "브랜드를 입력해주세요.", input: $brand)
                    InputView(title: "사이즈", placeholder: "사이즈를 입력해주세요.", input: $size)
                    InputView(title: "보관위치", placeholder: "의상이 보관된 위치를 입력해주세요.", input: $place)
                    seasonInputView
                    memoInputView
                }.padding(.horizontal, 20)
                
                Spacer().frame(height: 30)
            }
        }
        .background(Color.background)
        .navigationBarBackButtonHidden()
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
            if let clothData = viewModel.clothData {
                name = clothData.name
                category = clothData.categoryObject
                brand = clothData.brand
                size = clothData.size
                place = clothData.place
                
                let seasonList = clothData.seasonList
                
                spring = seasonList.contains(.spring)
                summer = seasonList.contains(.summer)
                fall = seasonList.contains(.fall)
                winter = seasonList.contains(.winter)
                memo = clothData.clothBody
            }
        }
    }
    
    var imageInputView: some View {
        VStack(spacing: 10) {
            if let selectedImagePreview = viewModel.selectedImagePreview {
                Button {
                    viewModel.send(.imageDisselected)
                } label: {
                    selectedImagePreview
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray0, lineWidth: 1))
                }
            } else {
                Image("photo")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .padding(50)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray0, lineWidth: 1))
            }
            
            PhotosPicker(
                selection: $selectedImage,
                matching: .images
            ) {
                Group {
                    Image(systemName: "camera")
                    Text("이미지 선택하기")
                }
                .foregroundStyle(Color.bk)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 30)
            .background(Color.gray0)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onChange(of: selectedImage) { _ in
                viewModel.send(.imageSelected(selectedImage))
            }
        }
        .padding(.vertical, 10)
    }
    
    var categoryInputView: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .leading) {
                Text("카테고리")
                    .font(.system(size: 15))
                
                Picker("카테고리", selection: $category) {
                    ForEach(Category.allCases.prefix(4)) { category in
                        Text(category.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .accentColor(.black)
                
                Picker("카테고리", selection: $category) {
                    ForEach(Category.allCases.suffix(from: 4)) { category in
                        Text(category.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .accentColor(.black)
            }
            Spacer()
        }
    }
    
    var seasonInputView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("계절")
                    .font(.system(size: 15))
                
                HStack {
                    SeasonToggleView(title: "봄", isOn: $spring)
                    SeasonToggleView(title: "여름", isOn: $summer)
                    SeasonToggleView(title: "가을", isOn: $fall)
                    SeasonToggleView(title: "겨울", isOn: $winter)
                }
            }
            Spacer()
        }
    }
    
    var memoInputView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("메모")
                    .font(.system(size: 15))
                
                TextEditor(text: $memo)
                    .frame(height: 150)
                    .border(Color.gray0, width: 1)
                    .font(.system(size: 14))
                    .scrollContentBackground(.hidden)
            }
            Spacer()
        }
        
    }
    
    struct InputView: View {
        let title: String
        let placeholder: String
        @Binding var input: String
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 15))
                    TextField(text: $input) {
                        Text(placeholder)
                    }
                    .font(.system(size: 15))
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray0))
                }
            }
        }
    }
    
    struct SeasonToggleView: View {
        let title: String
        @Binding var isOn: Bool
        
        var body: some View {
            Toggle(isOn: $isOn) {
                Rectangle()
                    .stroke(Color.bk)
                    .frame(width: 15, height: 15)
                    .overlay {
                        if isOn {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 10, height: 10)
                        }
                    }
                Text(title)
            }
            .toggleStyle(.button)
            .foregroundStyle(Color.bk)
            .tint(Color.mainGreen)
        }
    }
}

#Preview {
    ClothView(viewModel: ClothViewModel(container: .stub, clothData: .stub))
}
