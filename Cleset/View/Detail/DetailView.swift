//
//  DetailView.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import SwiftUI
import Kingfisher

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: DetailViewModel
    @EnvironmentObject var container: DIContainer
    @State var groupListViewPresent: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .renderingMode(.template)
                        .foregroundStyle(Color.mainGreen)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image("edit")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal, 20)
            .frame(minWidth: UIScreen.main.bounds.width, minHeight: 50, maxHeight: 50)
            
            ScrollView {
                VStack(alignment: .leading, spacing: .zero) {
                    ZStack {
                        KFImage(viewModel.clothData.imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: UIScreen.main.bounds.width - 30, minHeight: 250, maxHeight: 250)
                            .padding(.bottom, 10)
                        
                        VStack {
                            HStack {
                                Spacer()
                            }
                            Spacer()
                            HStack(spacing: 15) {
                                Spacer()
                                Button {
                                    groupListViewPresent.toggle()
                                } label: {
                                    Image("folderAdd")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
                                .shadow(radius: 1)
                                .sheet(isPresented: $groupListViewPresent, content: {
                                    GroupListView(viewModel: GroupListViewModel(container: container, clothItem: viewModel.clothData))
                                        .presentationDetents([.medium])
                                        .presentationDragIndicator(.automatic)
                                })
                                
                                Button {
                                    viewModel.send(.toggleFavorite)
                                } label: {
                                    Image(systemName: viewModel.clothData.favBool ? "heart.fill" : "heart")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(Color.red)
                                        .frame(width: 18, height: 16)
                                }
                                .shadow(radius: 1)
                                
                            }
                            .padding(20)
                        }
                        
                    }
                    
                    
                    Text(viewModel.clothData.name)
                        .font(.system(size: 17, weight: .bold))
                        .lineLimit(1)
                        .padding(.bottom, 10)
                    
                    Text("브랜드: \(viewModel.clothData.brand)")
                        .font(.system(size: 13))
                        .lineLimit(1)
                        .padding(.bottom, 1)
                    
                    Text("사이즈: \(viewModel.clothData.size)")
                        .font(.system(size: 13))
                        .lineLimit(1)
                        .padding(.bottom, 1)
                    
                    Text("보관 위치: \(viewModel.clothData.place)")
                        .font(.system(size: 13))
                        .lineLimit(1)
                        .padding(.bottom, 1)
                    
                    Text("분류: \(viewModel.clothData.category)")
                        .font(.system(size: 13))
                        .lineLimit(1)
                        .padding(.bottom, 10)
                    
                    
                    VStack(alignment: .leading, spacing: .zero) {
                        HStack {
                            Text("메모")
                                .font(.system(size: 14, weight: .bold))
                            
                            Image("memo")
                                .resizable()
                                .frame(width: 17, height: 17)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        
                        Text(viewModel.clothData.clothBody)
                            .font(.system(size: 12))
                            
                    }
                    .padding(10)
                    .background(
                        Color.logoBg
                            .shadow(radius: 1)
                    )
                    
                    HStack {
                        Spacer()
                        Text(viewModel.clothData.displayDate)
                            .font(.system(size: 10))
                            .lineLimit(1)
                            .foregroundStyle(Color.gray)
                            .padding(.top, 10)
                    }
                    
                        
                           
                    
                }
                .padding(.horizontal, 30)
            }
        }
        .navigationBarBackButtonHidden()
    }

}

#Preview {
    DetailView(viewModel: .init(clothData: .stub, container: .stub))
}
