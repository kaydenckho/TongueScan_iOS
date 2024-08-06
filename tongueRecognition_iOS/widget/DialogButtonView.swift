//
//  CardView.swift
//  tongueRecognition_iOS
//
//  Created by user on 2023/6/9.
//

import SwiftUI

struct DialogButtonView: View {
    
    let text: String
    
    let width: CGFloat
    
    let backgroundColor: Color
    let borderColor: Color
    let textColor: Color
    let isTextBold: Bool
    let fontSize: Font
    let cornerRadius: CGFloat
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(backgroundColor)
                    .stroke(borderColor, lineWidth: 1)
                Text(text)
                    .font(fontSize)
                        .foregroundColor(textColor)
                        .padding([.leading, .trailing], 15)
                        .padding([.top, .bottom], 5)
                        .lineLimit(1)
                        .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .fontWeight(isTextBold ? .bold : .regular)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(minWidth: width, maxWidth: width)
    }
}
