//
//  HomeView.swift
//  Cleset
//
//  Created by 엄태양 on 4/25/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        VStack {
            header
            myClothList
        }
        .onAppear {
            viewModel.send(.fetchClothes)
        }
    }
    
    var header: some View {
        HStack {
            Image("logo3")
                .resizable()
                .frame(width: 150, height: 30)
            Spacer()
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    var myClothList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.clothes, id: \.clothData.clothId) { viewModel in
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
}

#Preview {
    HomeView(viewModel: HomeViewModel(container: .stub))
}
