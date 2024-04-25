//
//  MainTabView.swift
//  Cleset
//
//  Created by 엄태양 on 4/25/24.
//

import SwiftUI

enum TabType {
    case board
    case home
    case profile
}

struct MainTabView: View {
    @State var selectedTab: TabType = .home
    
    var body: some View {
        VStack {
            Spacer()
            
            switch selectedTab {
                case .board:
                    BoardView()
                case .home:
                    HomeView()
                case .profile:
                    ProfileView()
            }
            
            Spacer()
            tabbar
        }
    }
    
    var tabbar: some View {
        
        HStack {
            
            Spacer()
            
            Button {
                selectedTab = .board
            } label: {
                Image(systemName: "line.3.horizontal")
                    .resizable()
                    .frame(width: 22, height: 17)
                    .foregroundStyle(selectedTab == .board ? Color.mainGreen : Color.gray)
            }
            
            
            Spacer()
            
            Button {
                selectedTab = .home
            } label: {
                Image("logo2")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundStyle(selectedTab == .home ? Color.mainGreen : Color.gray)
                
            }
            
            Spacer()
            
            Button {
                selectedTab = .profile
            } label: {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 23, height: 23)
                    .foregroundStyle(selectedTab == .profile ? Color.mainGreen : Color.gray)
                    .shadow(radius: 0)
            }
            
            Spacer()
            
        }
        .background(
            Color.logoBg
                .shadow(radius: 3)
                .ignoresSafeArea(edges: .bottom)
        )
        .padding(.bottom, -15)
    }
    
}

#Preview {
    MainTabView()
}
