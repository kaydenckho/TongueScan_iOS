//
//  CustomDialog.swift
//  tongueRecognition_iOS
//
//  Created by kayd3nckh on 20/12/2023.
//

import SwiftUI

struct TextDialog: View {
    @Binding var isActive: Bool
    
    @State var offset: CGFloat = 1000
    
    @State var titleArr: [String] = []
    @State var description: Text
    @State var leftButtonText:String = ""
    @State var rightButtonText:String = ""
    
    @State var textStyle = UIFont.TextStyle.footnote
    
    @State var leftBtnAction = {}
    @State var rightBtnAction = {}
    
    @Binding var trigger: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .opacity(0.5)
                    .onTapGesture {
                        close()
                    }
                
                VStack {
                    if (titleArr.count > 1){
                        VStack{
                            ForEach(titleArr, id: \.self) { string in
                                Text(string).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            }
                        }
                        .padding([.top, .bottom], 10)
                    } else{
                        Text(titleArr[0]).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding([.top, .bottom], 10)
                    }
                    ScrollView(){
                        VStack{
                            description
                                .font(.footnote)
                                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        }
                    }
                    .scrollIndicators(.visible, axes: .vertical)
                    .scrollIndicatorsFlash(trigger: trigger)
                    .padding([.bottom], 15)
                    .frame(minHeight:0, maxHeight:geometry.size.height*1/2)
                    HStack{
                        if (!leftButtonText.isEmpty){
                            Spacer()
                            Button(action: {
                                leftBtnAction()
                            }){
                                DialogButtonView(text: leftButtonText, width: 100, backgroundColor: Color("transparent"), borderColor: Color("orange"), textColor: .black, isTextBold: false, fontSize: .footnote, cornerRadius: 20)
                            }
                            .buttonStyle(ClickScaleDown())
                        }
                        Spacer()
                        if (!rightButtonText.isEmpty){
                            Button(action: {
                                rightBtnAction()
                            }){
                                DialogButtonView(text: rightButtonText, width: 100, backgroundColor: Color("orange"), borderColor:Color("orange"), textColor: .black, isTextBold: false, fontSize: .footnote, cornerRadius: 20)
                            }
                            .buttonStyle(ClickScaleDown())
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

extension String {
    func split(withMaxLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
}
