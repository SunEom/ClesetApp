//
//  ManageGroupView.swift
//  Cleset
//
//  Created by 엄태양 on 4/30/24.
//

import SwiftUI

struct ManageGroupView: View {
    @StateObject var viewModel: ManageGroupViewModel
    @State var presentingEditView: Bool = false
    @State var selectedGroup: ClothGroupObject? = nil
    @State var newGroupName: String = ""
    
    var body: some View {
        VStack {
            NavigationHeader<AnyView>(title: "그룹 관리")
            
            if viewModel.loading {
                Spacer()
                ProgressView()
            } else {
                if viewModel.groupList.isEmpty {
                    groupListEmptyView
                } else {
                    List {
                        ForEach(viewModel.groupList, id: \.folderId) { group in
                            HStack {
                                Text(group.folderName)
                                Spacer()
                                Button {
                                    print("tap")
                                    selectedGroup = group
                                    newGroupName = group.folderName
                                    presentingEditView = true
                                } label: {
                                    Image("edit")
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    viewModel.send(.deleteGroup(group))
                                } label: {
                                    Text("삭제")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            }
                            .tint(.red)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.send(.fetchGroupList)
        }
        .sheet(isPresented: Binding<Bool>(
            get: {
                presentingEditView && selectedGroup != nil
            },
            set: { _ in }
        ), content: {
            if let selectedGroup = selectedGroup {
                GroupEditView(group: selectedGroup, newGroupName: $newGroupName, viewModel: viewModel, isPresented: $presentingEditView) // 선택된 그룹의 시트만 표시
                    .presentationDetents([.height(200)])
                    .presentationDragIndicator(.automatic)
            }
        })
    }
    
    var groupListEmptyView: some View {
        VStack {
            Spacer()
            
            Image("emptyGroup")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("생성된 그룹이 없습니다")
            
            Spacer()
        }
    }
    
    struct GroupEditView: View {
        let group: ClothGroupObject
        @Binding var newGroupName: String
        let viewModel: ManageGroupViewModel
        @Binding var isPresented: Bool
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: .zero) {
                    HStack {
                        Text("그룹 이름 수정")
                            .font(.system(size: 17, weight: .semibold))
                        
                        Spacer()
                        
                        Button {
                            viewModel.send(.updateGroup(group: group, newName: newGroupName))
                            isPresented = false
                        } label: {
                            Text("저장")
                        }
                    }
                    .padding(.bottom, 15)
                    
                    Spacer()
                    
                    TextField(text: $newGroupName) {
                        Text("새로운 그룹 이름을 입력해주세요")
                    }
                    .padding(.bottom, 5)
                    
                    Rectangle()
                        .fill(Color.gray0)
                        .frame(height: 1)
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
            .onDisappear {
                newGroupName = ""
            }
        }
    }
}

#Preview {
    ManageGroupView(viewModel: ManageGroupViewModel(container: .stub))
}
