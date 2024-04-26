//
//  GroupListView.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import SwiftUI

struct GroupListView: View {
    @StateObject var viewModel: GroupListViewModel
    @State var newGroupName: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                header
                newGroupInput
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                groupList
            }
            .padding(.horizontal, 10)
            .padding(.top, 30)
            .onAppear {
                viewModel.send(.fetchGroupList)
            }
            .disabled(viewModel.loading)
            
            if viewModel.loading {
                GeometryReader { geometry in
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            
        }
    }
    
    var header: some View {
        HStack {
            Text("그룹에 추가하기")
                .font(.system(size: 19, weight: .bold))
            Spacer()
        }
    }
    
    var newGroupInput: some View {
        HStack {
            TextField(text: $newGroupName) {
                HStack {
                    Text("새로운 그룹 이름")
                    Spacer()
                }
            }
            .font(.system(size: 14))
            .padding(10)
            
            Button {
                if newGroupName != "" {
                    viewModel.send(.creatNewGroup(groupName: newGroupName))
                    newGroupName = ""
                }
            } label: {
                Image(systemName: "plus")
                    .renderingMode(.template)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                    .padding(5)
                    .background(
                        Circle()
                            .fill(Color.mainGreen)
                    )
            }
        }
    }
    
    var groupList: some View {
        ScrollView {
            LazyVStack {
                ForEach( viewModel.groups, id: \.folderId) { group in
                    Button {
                        print(group.folderName)
                    } label: {
                        HStack {
                            Text(group.folderName)
                            Spacer()
                        }
                        .background(Color.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

#Preview {
    GroupListView(viewModel: GroupListViewModel(container: .stub))
}
