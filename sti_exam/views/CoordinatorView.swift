//
//  CoordinatorView.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-03-14.
//

import SwiftUI

struct CoordinatorView: View {
    @EnvironmentObject var authDbViewAdapter: AuthDbViewAdapter
    @StateObject private var userAuthAdapter: UserAuthAdapter
    @StateObject private var homeViewAdapter: HomeViewAdapter

    init() {
        let authDbViewAdapter = AuthDbViewAdapter()
        _userAuthAdapter = StateObject(wrappedValue: UserAuthAdapter(authDbViewAdapter: authDbViewAdapter))
        _homeViewAdapter = StateObject(wrappedValue: HomeViewAdapter(authDbViewAdapter: authDbViewAdapter))
    }


    var body: some View {
        if userAuthAdapter.authDbViewAdapter.currentUser != nil {
            NavigationStack {
                HomeView()
                    .environmentObject(homeViewAdapter)
            }        
        } else {
            NavigationStack {
                LoginView()
                    .environmentObject(userAuthAdapter)
            }
        }
    }
}

struct CoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        let authDbViewAdapter = AuthDbViewAdapter()
        let userAuthAdapter = UserAuthAdapter(authDbViewAdapter: authDbViewAdapter)
        let homeViewAdapter = HomeViewAdapter(authDbViewAdapter: authDbViewAdapter)
        
        CoordinatorView()
            .environmentObject(userAuthAdapter)
            .environmentObject(homeViewAdapter)
    }
}
