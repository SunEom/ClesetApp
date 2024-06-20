//
//  PostCell.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import SwiftUI
import Kingfisher

struct PostCell: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: PostCellViewModel
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.postData.title)
                    .font(.system(size: 16, weight: .semibold))
                HStack {
                    Text(viewModel.postData.nickname)
                        .font(.system(size: 12))
                    
                    if let commentCount =  viewModel.postData.commentCount {
                        HStack(spacing: 3) {
                            Image("dot")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 6, height: 6)
                                .padding(.trailing, 5)
                             
                            Image("commentBubble")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 13, height: 13)
                            
                            Text("\(commentCount)")
                                .font(.system(size: 12))
                        }
                        .foregroundStyle(Color.bk)
                    }
                    
                }
            }
            
            Spacer()
                .frame(minWidth: 50)
            
            if let imageURL = viewModel.postData.imageURL {
                KFImage(imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .background (
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray, lineWidth: 1)
                    )
            }
            
        }
        .padding(.horizontal, 20)
        .frame(height: 60)

    }
}

#Preview {
    PostCell(viewModel: PostCellViewModel(postData: .stubList[0]))
}
