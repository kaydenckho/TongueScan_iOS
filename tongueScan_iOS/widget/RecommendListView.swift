//
//  RecommendList.swift
//  tongueScan_iOS
//
//  Created by kayd3nckh on 21/10/2024.
//

import SwiftUI

struct RecommendListView: View {
    
    let list: [ProductModel]
    var onItemClick: (ProductModel) -> Void // Closure for click action
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(list, id: \.self) { item in
                    ZStack{
                        Color(.white)
                            .cornerRadius(10)
                        VStack(alignment: .center){
                            AsyncImage(url: URL(string: item.img_link ?? "")) { image in
                                image.resizable()
                            } placeholder: {
                                Color("toolbarBackground")
                            }
                            
                            Text(item.name ?? "")
                                .foregroundColor(.black)
                         
                        }
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    }
                    .frame(width: 140, height: 220)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    .onTapGesture {
                        onItemClick(item) // Handle click action
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}


