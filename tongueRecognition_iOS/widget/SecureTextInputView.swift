//
//  CardView.swift
//  tongueRecognition_iOS
//
//  Created by user on 2023/6/9.
//

import SwiftUI

struct SecureTextInputView: View {
    
    let hint: String
    @Binding var input: String
    let image:String
    @Binding var isMasked: Bool
    
    var body: some View {
        ZStack(alignment: .trailing){
            HStack{
                Image(image)
                    .colorMultiply(Color("toolbarBackground"))
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5))
                if (isMasked){
                    SecureField("", text: $input, prompt: Text(hint).foregroundColor(Color("toolbarBackground")))
                        .fontWeight(.regular)
                        .font(.footnote)
                            .foregroundColor(.black)
                            .lineLimit(1)
                } else{
                    TextField("", text: $input, prompt: Text(hint).foregroundColor(Color("toolbarBackground")))
                        .fontWeight(.regular)
                        .font(.footnote)
                            .foregroundColor(.black)
                            .lineLimit(1)
                }
            }
            .padding([.top, .bottom], 11.0)
            .background(Color("login_textInput_bg"))
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: .infinity)
                Button(action: {
                    isMasked.toggle()
                }) {
                    Image(systemName: self.isMasked ? "eye.slash" : "eye")
                        .accentColor(.gray)
                }
                .padding([.trailing], 10.0)
        }
    }
}
