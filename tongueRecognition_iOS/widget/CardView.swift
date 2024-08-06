//
//  CardView.swift
//  tongueRecognition_iOS
//
//  Created by user on 2023/6/9.
//

import SwiftUI

struct CardView: View {
    
    let text: String
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color("cardBackground"))
                    .shadow(color: Color("cardBackground"), radius: 1.5, x: 0, y: 1.5)
                Text(text)
                        .font(.body)
                        .foregroundColor(Color("text"))
                        .padding([.leading, .trailing], 10)
                        .padding([.top, .bottom], 15)
                        .lineLimit(1)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity)
    }
}
