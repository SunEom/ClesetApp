//
//  ManageGroupList.swift
//  Cleset
//
//  Created by 엄태양 on 5/12/24.
//

import SwiftUI

struct ManageGroupList: View {
    @StateObject var viewModel: ManageGroupListViewModel
    @State var isPresentingEditView: Bool = false
    @State var selectedGroup: ClothGroupObject?
    @State var isPresentingDeleteAlertView: Bool = false
    
    var body: some View {
        VStack {
            NavigationHeader<AnyView>(title: ManageGroupMenu.manageGroupList.displayName)
            if viewModel.loading {
                Spacer()
                ProgressView()
            } else {
                if viewModel.groupList.isEmpty {
                    GroupListEmptyView()
                } else {
                    ScrollView {
                        ForEach(viewModel.groupList) { group in
                            GroupItem(
                                selectedGroup: $selectedGroup,
                                isPresentingEditView: $isPresentingEditView,
                                isPresentingDeleteAlertView: $isPresentingDeleteAlertView,
                                group: group
                            )
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: Binding<Bool>(get: {
            return isPresentingEditView && selectedGroup != nil
        }, set: { _ in}), content: {
            GroupEditView(
                group: selectedGroup!,
                newGroupName: selectedGroup!.folderName,
                viewModel: viewModel,
                isPresented: $isPresentingEditView
            )
            .presentationDetents([.height(200)])
            .presentationDragIndicator(.automatic)
            .onDisappear {
                selectedGroup = nil
            }
        })
        .onAppear {
            viewModel.send(.fetchGroupList)
        }
        .alert(isPresented: $isPresentingDeleteAlertView, content: {
            Alert(
                title: Text("경고"),
                message: Text("정말로 삭제하시겠습니까?"),
                primaryButton: .destructive(Text("삭제"), action: {
                    guard let selectedGroup = selectedGroup else {
                        isPresentingDeleteAlertView = false
                        selectedGroup = nil
                        return
                    }
                    viewModel.send(.deleteGroup(selectedGroup))
                
                    isPresentingDeleteAlertView = false
                    self.selectedGroup = nil
                }),
                secondaryButton: .cancel(Text("취소")) {
                    isPresentingDeleteAlertView = false
                    selectedGroup = nil
                }
            )
        })
        
    }
    
    struct GroupItem: View {
        @Binding var selectedGroup: ClothGroupObject?
        @Binding var isPresentingEditView: Bool
        @Binding var isPresentingDeleteAlertView: Bool
        let group: ClothGroupObject
        
        var body: some View {
            HStack {
                Text(group.folderName)
                
                Spacer()
                
                Button {
                    selectedGroup = group
                    isPresentingEditView = true
                } label: {
                    Image("edit")
                }
                
                Spacer().frame(width: 10)
                
                Button {
                    selectedGroup = group
                    isPresentingDeleteAlertView = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(Color.red)
                }
            }
            .padding(.vertical, 7)
        }
    }
    
    struct GroupEditView: View {
        let group: ClothGroupObject
        @State var newGroupName: String
        let viewModel: ManageGroupListViewModel
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
                isPresented = false
            }
        }
    }
}

#Preview {
    ManageGroupList(viewModel: ManageGroupListViewModel(container: .stub))
}
