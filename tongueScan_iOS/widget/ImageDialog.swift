//
//  CustomDialog.swift
//  tongueScan_iOS
//
//  Created by kayd3nckh on 20/12/2023.
//

import SwiftUI

struct ImageDialog: View {
    @Binding var isActive: Bool

    let image: Data
    @State private var offset: CGFloat = 1000

    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }

            VStack {
                Image(uiImage: UIImage(data: image)!)
                        .resizable()
                        .scaledToFit()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 20)
            .padding(30)
            .offset(x: 0, y: offset)
            .onAppear {
                    offset = 0
            }
        }
        .ignoresSafeArea()
    }

    func close() {
            offset = 1000
            isActive = false
    }
}
