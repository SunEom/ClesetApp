//
//  ManageAppView.swift
//  Cleset
//
//  Created by 엄태양 on 6/19/24.
//

import SwiftUI

struct ManageAppView: View {
    @EnvironmentObject var container: DIContainer
    @AppStorage(K.AppStorage.Appearance) var appearance: Int = UserDefaults.standard.integer(forKey: K.AppStorage.Appearance)
    
    var body: some View {
        VStack {
            NavigationHeader<AnyView>(title: "설정")
            
            HStack {
                Text("테마 설정")
                    .font(.system(size: 15, weight: .semibold))
                
                Spacer()
                
                Menu {
                    ForEach(AppearanceStyle.allCases, id: \.self) { a in
                        Button {
                            container.appearanceController.changeAppearance(a)
                            appearance = a.rawValue
                        } label: {
                            Text(a.label)
                                .font(.system(size: 13))
                        }
                    }
                } label: {
                    HStack {
                        Text(container.appearanceController.appearance.label)
                            .font(.system(size: 15, weight: .semibold))
                        
                        Image(systemName: "chevron.right")
                        
                    }
                    .foregroundStyle(.bk)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .background(Color.background)
    }
}


#Preview {
    ManageAppView()
}

