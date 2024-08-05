//
//  PasswordView.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-22.
//

import SwiftUI

struct PasswordView: View {
    @ObservedObject var authDbViewAdapter: AuthDbViewAdapter
    @Binding var userNameInput: String
    var customLabel: String
    var textSize: CGFloat
    
    var body: some View {
        VStack() {
            ZStack(alignment: .center) {
                Rectangle()
                    .frame(width: GridPoints.custom(16),height: GridPoints.x4)
                    .rotationEffect(.degrees(-GridPoints.x1))
                    .clipped()
                    .modifier(TextFeildStyling(
                        customBgColor:
                            Color.white,
                        customBgStroke: Color.black))
                Text(customLabel)
                    .font(Font.custom("PermanentMarker-Regular", size: textSize))
                    .rotationEffect(.degrees(-GridPoints.x1))
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.bottom, GridPoints.half)
            }
            .padding(.bottom, -GridPoints.x2)
            .rotationEffect(.degrees(GridPoints.x1))
            SecureField("", text: $userNameInput)
                .modifier(TextFeildStyling(customBgColor: .white, customBgStroke: Color.white))
                .onChange(of: userNameInput) { newValue in
                               userNameInput = newValue.lowercased()
                           }
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    @State static var userNameInput: String = ""
    @State static var passwordInput: String = ""
    
    static var previews: some View {
        PasswordView(authDbViewAdapter: AuthDbViewAdapter(),
                     userNameInput: $userNameInput, customLabel: "Password", textSize: 14)
        .previewLayout(.sizeThatFits)
    }
}

