//
//  ClothCell.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import SwiftUI
import Kingfisher

struct ClothCell: View {
    @ObservedObject var viewModel: ClothCellViewModel
    
    var body: some View {
        HStack(spacing: .zero) {
            KFImage(viewModel.clothData.imageUrl)
                .resizable()
                .frame(width: 80, height: 100)
            
            VStack(alignment: .leading, spacing: .zero) {
                Text(viewModel.clothData.name)
                    .lineLimit(1)
                    .font(.system(size: 15, weight: .bold))
                    .padding(.bottom, 5)
                
                Text(viewModel.clothData.brand)
                    .lineLimit(1)
                    .font(.system(size: 12, weight: .semibold))
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.send(.toggleFavorite)
                    } label: {
                        Image(systemName: viewModel.clothData.favBool ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 23, height: 20)
                            .foregroundStyle(Color.red)
                    }
                }
                
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
            
            
            Spacer()
        }
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .background(
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 1)
        )
    }
}

#Preview {
    ClothCell(viewModel: ClothCellViewModel(clothData: .stub, container: .stub))
}
