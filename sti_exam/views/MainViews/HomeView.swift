//
//  HomeView.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-03-14.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeViewAdapter: HomeViewAdapter
    @EnvironmentObject var userAuthAdapter: UserAuthAdapter
    
    var body: some View {
        VStack {
            TopBarView()
            BottomBarView()
        }
        .navigationBarBackButtonHidden(true)
        .environmentObject(homeViewAdapter)
    }

}

#Preview {
    HomeView()
        .environmentObject(HomeViewAdapter(authDbViewAdapter: AuthDbViewAdapter()))
}
