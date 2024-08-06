//
//  CardView.swift
//  tongueRecognition_iOS
//
//  Created by user on 2023/6/9.
//

import SwiftUI

struct TextInputView: View {
    
    let hint: String
    @Binding var input: String
    let image:String
    
    var body: some View {
        HStack{
            Image(image)
                .colorMultiply(Color("toolbarBackground"))
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5))
            TextField("", text: $input, prompt: Text(hint).foregroundColor(Color("toolbarBackground")))
                .fontWeight(.regular)
                .font(.footnote)
                    .foregroundColor(.black)
                    .lineLimit(1)
        }
        .padding([.top, .bottom], 11.0)
        .background(Color("login_textInput_bg"))
        .fixedSize(horizontal: false, vertical: true)
        .frame(width: .infinity)
    }
}
