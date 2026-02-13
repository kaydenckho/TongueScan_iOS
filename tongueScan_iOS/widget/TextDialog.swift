import SwiftUI

struct TextDialog: View {
    @Binding var isActive: Bool
    @State var offset: CGFloat = 1000
    @State var titleArr: [String] = []
    @State var description: Text
    @State var leftButtonText: String = ""
    @State var rightButtonText: String = ""
    @State var textStyle = UIFont.TextStyle.footnote
    @State var leftBtnAction = {}
    @State var rightBtnAction = {}
    @Binding var trigger: Int
    
    // Add state to track scroll position
    @State private var isScrolledToEnd = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .opacity(0.5)
                    .onTapGesture {
                        close()
                    }
                
                VStack {
                    if titleArr.isEmpty {
                        EmptyView()
                    } else if titleArr.count > 1 {
                        VStack {
                            ForEach(titleArr, id: \.self) { string in
                                Text(string).fontWeight(.bold)
                            }
                        }
                        .padding([.top, .bottom], 10)
                    } else {
                        Text(titleArr[0]).fontWeight(.bold)
                            .padding([.top, .bottom], 10)
                    }
                    
                    // Modified ScrollView with scroll position tracking
                    ScrollView {
                        VStack {
                            description
                                .font(.footnote)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // GeometryReader to detect scroll position
                            GeometryReader { proxy in
                                Color.clear
                                    .preference(key: ScrollOffsetKey.self,
                                               value: proxy.frame(in: .named("scroll")).maxY)
                            }
                            .frame(height: 0)
                        }
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetKey.self) { maxY in
                        // Check if scrolled to bottom
                        // Adjust the threshold as needed (20 is a buffer)
                        if maxY < geometry.size.height + 20 {
                            isScrolledToEnd = true
                        }
                    }
                    .scrollIndicators(.visible, axes: .vertical)
                    .scrollIndicatorsFlash(trigger: trigger)
                    .padding([.bottom], 15)
                    .frame(minHeight: 0, maxHeight: geometry.size.height * 1/2)
                    
                    HStack {
                        if (!leftButtonText.isEmpty) {
                            Spacer()
                            Button(action: {
                                leftBtnAction()
                            }) {
                                DialogButtonView(text: leftButtonText,
                                                width: 100,
                                                backgroundColor: Color("transparent"),
                                                borderColor: Color("orange"),
                                                textColor: .black,
                                                isTextBold: false,
                                                fontSize: .footnote,
                                                cornerRadius: 20)
                            }
                            .buttonStyle(ClickScaleDown())
                        }
                        
                        Spacer()
                        
                        if (!rightButtonText.isEmpty) {
                            Button(action: {
                                rightBtnAction()
                            }) {
                                DialogButtonView(text: rightButtonText,
                                                width: 100,
                                                backgroundColor: isScrolledToEnd ? Color("orange") : Color("light_grey"),
                                                borderColor: isScrolledToEnd ? Color("orange") : Color("light_grey"),
                                                textColor: .black,
                                                isTextBold: false,
                                                fontSize: .footnote,
                                                cornerRadius: 20)
                            }
                            .buttonStyle(ClickScaleDown())
                            .disabled(!isScrolledToEnd) // Disable if not scrolled to end
                            Spacer()
                        }
                    }
                    .padding([.bottom], 15)
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
    }
    
    func close() {
        offset = 1000
        isActive = false
    }
}

// Preference key to track scroll offset
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
