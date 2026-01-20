import SwiftUI

struct Button1View: View {
    
    let text: String
    
    let width: CGFloat
    
    let color: Color
    
    let topLeading: CGFloat
    let bottomLeading: CGFloat
    let topTrailing: CGFloat
    let bottomTrailing: CGFloat

    let verticalPadding: CGFloat
    
    let textSize: Font
    
    let textColor : Color
    
    
    var body: some View {
            ZStack {
                UnevenRoundedRectangle(cornerRadii: .init(
                    topLeading: topLeading,
                    bottomLeading: bottomLeading,
                    bottomTrailing: bottomTrailing,
                    topTrailing: topTrailing),
                    style: .continuous)
                    .foregroundStyle(color)
                Text(text)
                    .fontWeight(.bold)
                    .font(textSize)
                        .foregroundColor(textColor)
                        .padding([.leading, .trailing], 10)
                        .padding([.top, .bottom], verticalPadding)
                        .lineLimit(1)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: width)
        
    }
}
