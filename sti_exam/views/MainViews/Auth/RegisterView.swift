//
//  SignUpView.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-03-14.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var userAuthAdapter: UserAuthAdapter
    @State var email = ""
    @State var confirmEmail = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var newRegistration = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if let viewModel = userAuthAdapter.registerViewModel{
            content(viewModel: viewModel)
            
        } else {
            ProgressView()
                .onAppear(perform: {
                    userAuthAdapter.generateRegisterViewModel()
                    
                })
        }
    }
    
    @ViewBuilder func content(viewModel: ViewModel) -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 18) {
                VStack {
                    EmailView(
                        authDbViewAdapter: userAuthAdapter.authDbViewAdapter,
                        userNameInput: $email,
                        customLabel: viewModel.emailTitle, textSize: 14)
                    .padding(.vertical)
                    EmailView(
                        authDbViewAdapter: userAuthAdapter.authDbViewAdapter,
                        userNameInput: $confirmEmail,
                        customLabel: viewModel.confirmEmailTitle, textSize: 12)
                    .padding(.vertical)
                    PasswordView(
                        authDbViewAdapter: userAuthAdapter.authDbViewAdapter,
                        userNameInput: $password,
                        customLabel: viewModel.passwordTitle, textSize: 14)
                    .padding(.bottom, GridPoints.x3)
                    PasswordView(
                        authDbViewAdapter: userAuthAdapter.authDbViewAdapter,
                        userNameInput: $confirmPassword,
                        customLabel: viewModel.confirmPasswordTitle, textSize: 12)
                    .padding(.bottom, GridPoints.x3)
                }
                .padding(.horizontal, GridPoints.x2)
                Divider()
                    .rotationEffect(Angle(degrees: -GridPoints.x1))
                
                NavigationLink(
                    destination: HomeView()
                        .environmentObject(userAuthAdapter),
                    isActive: $newRegistration,
                    label: { EmptyView() }
                )
                .hidden()
                
                Text(viewModel.registerTitle)
                    .font(.title2)
                    .bold()
                    .padding(.vertical, GridPoints.x1)
                    .padding(.horizontal, GridPoints.x3)
                    .background(.white)
                    .cornerRadius(8)
                    .shadow(color: Color.brown.opacity(0.6), radius: 8, x: 0, y: 2)
                    .onTapGesture {
                        if !email.isEmpty && email == confirmEmail && !password.isEmpty && password == confirmPassword {
                            viewModel.registerAction(email, password) { success in
                                if success {
                                    newRegistration = true
                                } else {
                                    
                                }
                            }
                        }
                    }
                
                Text(viewModel.cancelTitle)
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.vertical, GridPoints.x1)
                    .padding(.horizontal, GridPoints.x3)
                    .background(.black)
                    .border(.white, width: 3)
                    .cornerRadius(8)
                    .padding(.bottom, GridPoints.x2)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            .background()
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
                            .yellow.opacity(0.2),
                            .yellow.opacity(1.8)]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.bottom)
            )
    }
    
    struct ViewModel {
        let appTitle: String
        let cancelTitle: String
        let registerTitle: String
        let passwordTitle: String
        let confirmPasswordTitle: String
        let emailTitle: String
        let confirmEmailTitle: String
        let registerAction: (String, String, @escaping (Bool) -> Void) -> Void
    }
}

#Preview {
    RegisterView(userAuthAdapter: UserAuthAdapter(authDbViewAdapter: AuthDbViewAdapter()),
                 email: "", confirmEmail: "", password: "", confirmPassword: "")
}
