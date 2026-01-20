//
//  CardView.swift
//  tongueRecognition_iOS
//
//  Created by user on 2023/6/9.
//

import SwiftUI

struct LoadingView: View {

    @State var text:String
    
    var body: some View {
        ZStack {
            ProgressView(text)
                .scaleEffect(1)
                .tint(.white)
                .foregroundColor(.white)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("grey86"))
    }
}
