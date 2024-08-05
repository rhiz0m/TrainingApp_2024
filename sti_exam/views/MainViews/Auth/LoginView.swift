//
//  LoginView.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-03-14.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userAuthAdapter: UserAuthAdapter
    @State private var navigateToHome = false
    
    var body: some View {
        if let viewModel = userAuthAdapter.loginViewModel{
            content(viewModel: viewModel)
            NavigationLink(
                destination: HomeView()
                    .environmentObject(userAuthAdapter),
                isActive: $navigateToHome,
                label: { EmptyView() })
        } else {
            ProgressView()
                .onAppear(perform: {
                    userAuthAdapter.generateLoginViewModel()
                })
        }
    }
    
    @ViewBuilder func content(viewModel: ViewModel) -> some View {
        ZStack(alignment: .bottom) {
            backgroundImageView(imageName: viewModel.image)
            
            Divider()
                .rotationEffect(Angle(degrees: -GridPoints.x1))
                .padding(.bottom, GridPoints.x8)
            
                VStack {
                    EmailView(
                        authDbViewAdapter: userAuthAdapter.authDbViewAdapter,
                        userNameInput: $userAuthAdapter.authDbViewAdapter.emailInput,
                        customLabel: viewModel.emailTitle, textSize: 14)
                    .padding(.vertical)
                    
                    PasswordView(authDbViewAdapter: userAuthAdapter.authDbViewAdapter,
                                 userNameInput: $userAuthAdapter.authDbViewAdapter.passwordInput,
                                 customLabel: viewModel.passwordTitle, textSize: 12)
                    .padding()
         
                    Text(viewModel.loginTitle)
                        .font(.title2)
                        .bold()
                        .padding(.vertical, GridPoints.x1)
                        .padding(.horizontal, GridPoints.x3)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.brown.opacity(0.6), radius: 8, x: 0, y: 2)
                        .onTapGesture {
                            if !userAuthAdapter.authDbViewAdapter.emailInput.isEmpty && !userAuthAdapter.authDbViewAdapter.passwordInput.isEmpty {
                                viewModel.loginAction { success in
                                    if success {
                                        navigateToHome = true
                                    } else {
                                        
                                    }
                                }
                            }
                        }
                    
                    
                    NavigationLink(destination: RegisterView(
                        userAuthAdapter: userAuthAdapter),
                                   label: {
                        Text(viewModel.registerTitle)
                            .foregroundStyle(CustomColors.cyan)
                    })
                    .bold()
                    .padding(.vertical, GridPoints.x1)
                    .padding(.horizontal, GridPoints.x3)
                    .background(.black)
                    .border(.cyan, width: 0.5)
                    .cornerRadius(8)
                    .padding(.vertical, GridPoints.x2)
                }
                .padding(.horizontal, GridPoints.x8)
                .padding(.bottom)
        }
        .padding(GridPoints.half)
        .navigationBarBackButtonHidden(true)
        
    }
    
    @ViewBuilder private func backgroundImageView(imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.bottom)
            .overlay(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.cyan.opacity(0.2),
                            Color.black.opacity(1)]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.bottom)
            )
    }
    
    struct ViewModel {
        let image: String
        let appTitle: String
        let loginTitle: String
        let registerTitle: String
        let passwordTitle: String
        let emailTitle: String
        let loginAction: (@escaping (Bool) -> Void) -> Void
    }
}

#Preview {
    LoginView()
}
