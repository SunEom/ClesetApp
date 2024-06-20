//
//  HomeView.swift
//  Cleset
//
//  Created by 엄태양 on 4/25/24.
//

import SwiftUI

enum HomeFilterType: CaseIterable {
    case all
    case season
    case category
    case group
    case favorite
    
    var title: String {
        get {
            switch self {
                case .all:
                    "전체"
                case .season:
                    "계절별"
                case .category:
                    "카테고리별"
                case .group:
                    "그룹별"
                case .favorite:
                    "좋아요"
            }
        }
    }
}

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var container: DIContainer
    @State var searchWord: String = ""
    @State var selectedFilter: HomeFilterType = .all
    @State var selectedSeason: Season = .spring
    @State var selectedCategory: Category = .shirt
    @State var selectedGroup: ClothGroupObject?
    
    var body: some View {
        ZStack {
            VStack(spacing: .zero) {
                header
                
                listHeader
                
                if selectedFilter == .season {
                    seasonHeader
                        .onAppear {
                            viewModel.send(.fetchSeasonClothes(selectedSeason))
                        }
                }
                
                if selectedFilter == .category {
                    categoryHeader
                        .onAppear {
                            viewModel.send(.fetchCategoryClothes(selectedCategory))
                        }
                }
                
                if selectedFilter == .group {
                    groupHeader
                        .onAppear {
                            viewModel.send(.fetchClothGroups)
                            viewModel.send(.groupTabSelected)
                        }
                        .onDisappear {
                            selectedGroup = nil
                        }
                }
                
                SearchBar(searchWord: $searchWord)
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                
                if viewModel.loading {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    if
                        (selectedFilter != .group && viewModel.clothes.isEmpty)
                            || (selectedFilter == .group && selectedGroup != nil && viewModel.clothes.isEmpty) {
                        ClothListEmptyView()
                    } else {
                        myClothList
                    }
                }
                
            }
            .onAppear {
                viewModel.send(.fetchClothes)
            }
            
            newClothButton
       
        }
        .background(Color.background)
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
    
    var listHeader: some View {
        ScrollView(.horizontal) {
            VStack(spacing: .zero) {
                HStack(spacing: .zero) {
                    ForEach(HomeFilterType.allCases, id: \.self) { type  in
                        HomeFilterButton(selectedType: $selectedFilter, type: type, viewModel: viewModel)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Rectangle()
                    .fill(Color.gray0)
                    .frame(height: 1)
            }
        }
        .scrollIndicators(.hidden)
        .padding(.top, 20)
    }
    
    var seasonHeader: some View {
        HStack(alignment: .center) {
            Spacer()
            HomeSeasonButton(selectedSeason: $selectedSeason, viewModel: viewModel, season: .spring)
            Spacer()
                .frame(width: 30)
            HomeSeasonButton(selectedSeason: $selectedSeason, viewModel: viewModel, season: .summer)
            Spacer()
                .frame(width: 30)
            HomeSeasonButton(selectedSeason: $selectedSeason, viewModel: viewModel, season: .fall)
            Spacer()
                .frame(width: 30)
            HomeSeasonButton(selectedSeason: $selectedSeason, viewModel: viewModel, season: .winter)
            Spacer()
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.top, 15)
    }
    
    var categoryHeader: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .center, spacing: 20) {
                ForEach(Category.allCases, id: \.self) { category in
                    HomeCategoryButton(selectedCategory: $selectedCategory, viewModel: viewModel, category: category)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 15)
        }
        .padding(.horizontal, 20)
        .scrollIndicators(.hidden)
    }
    
    var myClothList: some View {
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
                
                Spacer().frame(height: 100)
            }
            .padding(.vertical, 5)
        }
        .padding(.top, 10)
    }
    
    var groupHeader: some View {
        VStack(spacing: .zero) {
            ScrollView(.horizontal) {
                
                if viewModel.groupList.isEmpty {
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
                        ForEach(viewModel.groupList, id: \.folderId) { group in
                            HomeGroupButton(selectedGroup: $selectedGroup, group: group, viewModel: viewModel)
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
    
    var newClothButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink {
                    ClothView(viewModel: ClothViewModel(container: container))
                } label: {
                    ZStack {
                        Image("manageClothByGroup")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35)
                            .foregroundStyle(Color.white)
                            .padding(.top, 5)
                            .padding(.leading, -5)
                        
                        Image(systemName: "plus")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 10)
                            .bold()
                            .foregroundStyle(Color.white)
                            .padding(.top, -23)
                            .padding(.leading, 18)
                            
                    }
                }
                .padding(15)
                .background(Color.mainGreen)
                .clipShape(Circle())
                .shadow(radius: 3)
            }
            .padding(.all, 20)
        }
    }
    
}

struct HomeFilterButton: View {
    @Binding var selectedType: HomeFilterType
    let type: HomeFilterType
    let viewModel: HomeViewModel
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                selectedType = type
                if type == .all {
                    viewModel.send(.fetchClothes)
                }
            }
        } label: {
            VStack(spacing: 10) {
                Text(type.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(selectedType == type ? Color.mainGreen : Color.gray)
                
                if selectedType == type {
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

struct HomeSeasonButton: View {
    @Binding var selectedSeason: Season
    var viewModel: HomeViewModel
    var season: Season
    
    var body: some View {
        Button {
            selectedSeason = season
            viewModel.send(.fetchSeasonClothes(season))
        } label: {
            VStack(spacing: 10) {
                Image(season.imageName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .background(
                        Circle()
                            .fill(selectedSeason == season ? Color.subGreen : Color.clear)
                            .frame(width: 40, height: 40)
                    )
                
                Text(season.displayName)
                    .font(.system(size: 12))
                    .foregroundStyle(selectedSeason == season ? Color.bk : Color.gray)
            }
        }
    }
}

struct HomeCategoryButton: View {
    @Binding var selectedCategory: Category
    var viewModel: HomeViewModel
    let category: Category
    
    var body: some View {
        Button {
            selectedCategory = category
            viewModel.send(.fetchCategoryClothes(category))
        } label: {
            VStack(spacing: 10) {
                Image(category.imageName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .background(
                        Circle()
                            .fill(selectedCategory == category ? Color.subGreen : Color.clear)
                            .frame(width: 40, height: 40)
                    )
                
                Text(category.rawValue)
                    .font(.system(size: 12))
                    .foregroundStyle(selectedCategory == category ? Color.bk : Color.gray)
            }
        }
    }
}

struct HomeGroupButton: View {
    @Binding var selectedGroup: ClothGroupObject?
    let group: ClothGroupObject
    let viewModel: HomeViewModel
    
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
    HomeView(viewModel: HomeViewModel(container: .stub))
}

