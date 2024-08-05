//
//  LoginViewAdapter.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-27.
//

import Foundation

class UserAuthAdapter: ObservableObject {
    @Published var loginViewModel: LoginView.ViewModel?
    @Published var registerViewModel: RegisterView.ViewModel?
    
    var authDbViewAdapter: AuthDbViewAdapter
    
    init(authDbViewAdapter: AuthDbViewAdapter) {
        self.authDbViewAdapter = authDbViewAdapter
    }
    
    func generateLoginViewModel() {
        let loginViewModel = LoginView.ViewModel(
            image: "gym_man",
            appTitle: LocalizedStrings.apptitle,
            loginTitle: LocalizedStrings.login,
            registerTitle: LocalizedStrings.register,
            passwordTitle: LocalizedStrings.password,
            emailTitle: LocalizedStrings.email,
            loginAction: { [weak self] completion in
                guard let self = self else { return }
                self.authDbViewAdapter.loginUser(
                    email: self.authDbViewAdapter.emailInput,
                    password: self.authDbViewAdapter.passwordInput) { success in
                        completion(success)
                    }
            }
        )
        self.loginViewModel = loginViewModel
    }
    
    func generateRegisterViewModel() {
        let registerViewModel = RegisterView.ViewModel(
            appTitle: LocalizedStrings.apptitle,
            cancelTitle: LocalizedStrings.cancel,
            registerTitle: LocalizedStrings.register,
            passwordTitle: LocalizedStrings.password,
            confirmPasswordTitle: LocalizedStrings.confirmPassword,
            emailTitle: LocalizedStrings.email,
            confirmEmailTitle: LocalizedStrings.confirmEmail,
            
            registerAction: { [weak self] email, password, completion in
                guard let self = self else { return }
                self.authDbViewAdapter.registerUser(email: email, password: password) { success in
                    completion(success)
                }
            }
        )
        self.registerViewModel = registerViewModel
    }
}
