//
//  BoardListView.swift
//  Cleset
//
//  Created by 엄태양 on 4/25/24.
//

import SwiftUI

enum BoardType: String, CaseIterable, Identifiable {
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
    
    var image: String {
        get {
            switch self {
                case .fashion:
                    "hanger"
                case .tip:
                    "lightBlub"
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
            
            List {
                ForEach(BoardType.allCases, id:\.self) { board in
                    NavigationLink {
                        BoardView(viewModel: BoardViewModel(container: container, boardType: board))
                    } label: {
                        HStack {
                            Text(board.displayName)
                            Image(board.image)
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    BoardListView()
}
