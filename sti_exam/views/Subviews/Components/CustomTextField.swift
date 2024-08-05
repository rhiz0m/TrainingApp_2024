
//
//  CustomTextFeild.swift
//  trainingApp
//
//  Created by Andreas Antonsson on 2023-10-07.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var textInput: String
    
    var fixedHeight: CGFloat = 44
    var fontSize: CGFloat = CGFloat(16)
    var title: String
    
    var body: some View {
        VStack {
            ZStack() {
                TextField("", text: $textInput)
                    .autocapitalization(.none)
                    .padding(.leading, GridPoints.custom(1.5))
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(height: fixedHeight)
                    .background(.black)
                    .cornerRadius(GridPoints.x6)
                
                    .padding(GridPoints.half)
                    .overlay(
                        RoundedRectangle(cornerRadius: GridPoints.x6)
                            .stroke(LinearGradient(gradient: Gradient(colors: [CustomColors.darkerCyan.opacity(0.8), Color.white.opacity(0.6)]), startPoint: .bottom, endPoint: .top), lineWidth: 1)
                    )
                    .overlay(
                        Text(textInput.isEmpty ? title : textInput)
                            .foregroundColor(textInput.isEmpty ? Color(CustomColors.cyan) : Color.white)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            
                    )
            }
        }
    }
}

struct CustomTextFeild_Previews: PreviewProvider {
    @State static var textInput: String = ""
    
    static var previews: some View {
        CustomTextField(textInput: $textInput, title: "textFeild Title")
            .previewLayout(.sizeThatFits)
        
    }
}
