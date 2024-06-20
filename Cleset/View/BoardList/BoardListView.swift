//
//  BoardListView.swift
//  Cleset
//
//  Created by 엄태양 on 4/25/24.
//

import SwiftUI

enum BoardType: String, CaseIterable, Identifiable, MenuItemType {
    var id: Self { self }
    case fashion = "fashion"
    case tip = "tip"
    
    var typeString: String {
        switch self {
            case .fashion:
                "fashion"
            case .tip:
                "tip"
        }
    }
    
    var displayName: String {
        get {
            switch self {
                case .fashion:
                    "나만의 패션 코디"
                case .tip:
                    "의상 관리 꿀팁"
            }
        }
    }
    
    var image: Image {
        get {
            switch self {
                case .fashion:
                    Image("hanger")
                case .tip:
                    Image("lightBlub")
            }
        }
    }
}

struct BoardListView: View {
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        VStack {
            
            Text("게시글 목록")
                .font(.system(size: 18, weight: .semibold))
            
            VStack {
                ForEach(BoardType.allCases, id:\.self) { board in
                    NavigationLink {
                        BoardView(viewModel: BoardViewModel(container: container, boardType: board))
                    } label: {
                        MenuItem(menu: board)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 10)
            
            Spacer()
        }
        .background(Color.background)
    }
}

#Preview {
    BoardListView()
}
