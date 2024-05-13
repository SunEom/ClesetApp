//
//  ManageClothByGroupView.swift
//  Cleset
//
//  Created by 엄태양 on 5/12/24.
//

import SwiftUI

struct ManageClothByGroupView: View {
    @EnvironmentObject var container: DIContainer
    @State var selectedGroup: ClothGroupObject?
    @StateObject var viewModel: ManageClothByGroupViewModel
    @State var searchWord: String = ""
    
    var body: some View {
        VStack {
            NavigationHeader<AnyView>(title: ManageGroupMenu.manageClothByGroup.displayName)
            groupHeader
            
            SearchBar(searchWord: $searchWord)
                .padding(.horizontal, 20)
                .padding(.vertical, 3)
            
            if selectedGroup != nil && viewModel.clothes.isEmpty {
                ClothListEmptyView()
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.getFilteredList(for: searchWord), id: \.clothData.clothId) { viewModel in
                            NavigationLink {
                                DetailView(
                                    viewModel: DetailViewModel(
                                        clothData: viewModel.clothData,
                                        container: container
                                    )
                                )
                            } label: {
                                ClothCell(viewModel: viewModel)
                                    .padding(.horizontal, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                    }
                    .padding(.vertical, 5)
                }
                .padding(.top, 10)
            }
            Spacer()
            
        }
        .onAppear {
            viewModel.send(.fetchGroups)
        }
        .navigationBarBackButtonHidden()
    }
    
    var groupHeader: some View {
        VStack(spacing: .zero) {
            ScrollView(.horizontal) {
                if viewModel.groups.isEmpty {
                    HStack {
                        Spacer()
                        Text("생성된 그룹이 없습니다")
                            .font(.system(size: 13))
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.bottom, 10)
                    
                } else {
                    LazyHStack(spacing: .zero) {
                        ForEach(viewModel.groups, id: \.folderId) { group in
                            GroupButton(
                                selectedGroup: $selectedGroup,
                                group: group,
                                viewModel: viewModel
                            )
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
            }
            .scrollIndicators(.hidden)
            .padding(.top, 20)
            .frame(height: 50)
            
            Rectangle()
                .fill(Color.gray0)
                .frame(height: 1)
        }
    }
}

struct GroupButton: View {
    @Binding var selectedGroup: ClothGroupObject?
    let group: ClothGroupObject
    let viewModel: ManageClothByGroupViewModel
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                selectedGroup = group
                viewModel.send(.fetchGroupCloth(group))
            }
        } label: {
            VStack(spacing: 10) {
                Text(group.folderName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(selectedGroup?.folderId == group.folderId ? Color.mainGreen : Color.gray)
                
                if selectedGroup?.folderId == group.folderId {
                    Rectangle()
                        .fill(Color.mainGreen)
                        .frame(height: 2)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 2)
                }
                
            }
            .frame(width: 100)
        }
    }
}

#Preview {
    ManageClothByGroupView(viewModel: ManageClothByGroupViewModel(container: .stub))
}
