//
//  ImageSlider.swift
//  tongueScan_iOS
//
//  Created by kayd3nckh on 11/12/2023.
//

import SwiftUI

struct ImageSlider: View {
    
    let images: [ImageModel]
    
    var body: some View {
            TabView {
                    ForEach(images, id: \.self) { item in
                        Image(uiImage: UIImage(data: item.originalImg!)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill) /// no need for custom aspect ratio
                            .clipped() /// stop image from overflowin
                    }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode:.always))
    }
}
