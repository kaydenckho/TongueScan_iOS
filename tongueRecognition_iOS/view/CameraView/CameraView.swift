import SwiftUI
import JPSVolumeButtonHandler

struct CameraView: View {
    
    @Binding var isPageActive: Bool
    
    @Binding var language : String?
    
    enum Mode {
        case Auto
        case Manual
    }

    let mode :Mode
    
    @State var isTouched = false
    @State var touchedX = 0.0
    @State var touchedY = 0.0
    @State var hideRectangle:DispatchWorkItem? = nil
    
    @StateObject private var vm = CameraViewVM()
    
    @State private var volumeHandler: JPSVolumeButtonHandler?
    
    @State var isEnterFirstTime = true
    
    @Binding var tabViewSelection:Int
    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    ErrorView(error: vm.error)
                    ZStack{
                        FrameView(image: vm.frame)
                        RoundedRectangle(cornerRadius:  0)
                        .fill(Color("transparent"))
                        .stroke(Color("toolbarBackground"), lineWidth: 1.5)
                        .frame(width: isTouched ? 130*0.8 : 130, height: isTouched ? 110*0.8 : 110)
                        .opacity(isTouched ? 1.0 : 0.0)
                        .position(x:touchedX, y:touchedY)
                        .animation(.easeInOut(duration: 0.5), value: isTouched ? 0.8 : 1.0)
                        Image("tongue_shape").resizable().frame(width: geometry.size.width/3, height: geometry.size.height/5)
                            .position(x: geometry.size.width/2, y: geometry.size.height/2.75)
                        "tongueHint".localizedText(language: language)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.subheadline)
                            .frame(maxWidth: geometry.size.width/1.2)
                            .position(x:geometry.size.width/2, y: geometry.size.height/1.6)
                            .multilineTextAlignment(.center)
                        if (mode == .Manual){
                            Slider(value: $vm.zoomRatio, in: 0...100)
                                .rotationEffect(.degrees(270), anchor: .topLeading)
                                .frame(width: geometry.size.height/2.4)
                                .offset(x: geometry.size.width * 0.79, y: geometry.size.height/4.6)
                        }
                        Button(action: {
                            if (!vm.isCapturing){
                                vm.takePicture()
                            }
                        }){
                            Image("capture_icon").resizable().frame(width: 45, height: 45)
                        }
                        .opacity(vm.frame != nil && mode == .Manual ? 1 : 0)
                        .position(x:geometry.size.width/2, y: geometry.size.height/1.1)
                        .buttonStyle(ClickScaleUp())
                    }
                    .opacity((vm.error == nil && vm.images.count == 0) ? 1.0 : 0.0)

                        ZStack{
                            TabView {
                                    ForEach(0..<vm.images.count, id: \.self) { index in
                                        Image(uiImage: UIImage(data: vm.images[index].originalImg!)!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width:geometry.size.width,height:geometry.size.height*0.8)
                                    }
                            }
                            .tabViewStyle(.page)
                            .frame(width:geometry.size.width,height:geometry.size.height*0.8)
                            .position(x:geometry.size.width/2, y:geometry.size.height/2-geometry.size.height*0.1)
                    
                            HStack(){
                                Spacer()
                                Button(action: {
                                    vm.resetCamera()
                                }){
                                    VStack{
                                        Image("retry_icon").resizable()
                                            .frame(
                                                width: 40, height: 40)
                                        "retry".localizedText(language: language)
                                            .foregroundColor(Color("grey86"))
                                            .fontWeight(.bold)
                                            .font(.footnote)
                                    }
                                }
                                .buttonStyle(ClickScaleUp())
                                Spacer()
                                Button(action: {
                                    if (!vm.isSavedPhoto){
                                        vm.saveImage()
                                    }
                                    if (!vm.uploading){
                                        Task{
                                            await vm.uploadImage(token: tongueRecognition_iOSApp.loginModel?.token ?? "")
                                        }
                                    }
                                }){
                                    VStack{
                                        Image("upload_icon").resizable()
                                            .frame(
                                                width: 50, height: 50)
                                        "upload_photo".localizedText(language: language)
                                            .foregroundColor(Color("grey86"))
                                            .fontWeight(.bold)
                                            .font(.footnote)
                                    }
                                }
                                .buttonStyle(ClickScaleUp())
                                .navigationDestination(isPresented: $vm.uploadSuccess){
                                    ResultView(isPageActive: $isPageActive, language: $language, result: vm.uploadImagesResult?.data, tabViewSelection: $tabViewSelection)
                                }
                                Spacer()
                                Button(action: {
                                    if (!vm.isSavedPhoto){
                                        vm.saveImage()
                                    }
                                    vm.showSavedPhotoAlert.toggle()
                                }){
                                    VStack{
                                        Image("save_icon").resizable().frame(
                                            width: 40, height: 40)
                                        "save_photo".localizedText(language: language)
                                            .foregroundColor(Color("grey86"))
                                            .fontWeight(.bold)
                                            .font(.footnote)
                                    }
                                }
                                .buttonStyle(ClickScaleUp())
                                Spacer()
                            }
                            .frame(width:geometry.size.width,height:geometry.size.height*0.3)
                            .position(x:geometry.size.width/2, y:geometry.size.height*0.9)
                        }
                        .opacity((vm.error == nil && vm.images.count == 2) ? 1.0 : 0.0)
                        .onAppear(){
                            vm.images.reverse()
                        }
                    LoadingView(text:"uploading".localizedString(language: language)).opacity(vm.uploading ? 1 : 0)
                }
                .onTapGesture {location in
                    var converted = CGPoint()
                    converted.x = (geometry.size.width - location.x) / geometry.size.width
                    converted.y = 1 - (geometry.size.height - location.y) / geometry.size.height
                    vm.touchToFocus(point: converted)
                    isTouched = true
                    touchedX = location.x
                    touchedY = location.y
                    if (hideRectangle != nil){
                        hideRectangle?.cancel()
                    }
                    hideRectangle = DispatchWorkItem(block: {
                        isTouched = false
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: hideRectangle!)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action:{isPageActive.toggle()}){
                            Image(systemName: "chevron.backward").foregroundColor(.white)
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        let title = (mode == Mode.Auto) ? "auto_mode" : "manual_mode"
                        title.localizedText(language: language)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color("toolbarBackground"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .onAppear(){
                    Task{
                        vm.startCamera(mode: mode)
                        volumeHandler = JPSVolumeButtonHandler(up: {
                            if (isEnterFirstTime){
                                isEnterFirstTime.toggle()
                            } else{
                                if (!vm.isCapturing && mode == .Manual){
                                    vm.takePicture()
                                }
                            }
                        }, downBlock: {
                            if (isEnterFirstTime){
                                isEnterFirstTime.toggle()
                            } else{
                                if (!vm.isCapturing && mode == .Manual){
                                    vm.takePicture()
                                }
                            }
                        })
                        volumeHandler?.start(true)
                    }
                
                }
                .onDisappear(){
                    Task{
                        volumeHandler?.start(false)
                        volumeHandler = nil
                        vm.stopCamera()
                    }
                }
                .alert("upload_failed_msg".localizedString(language: language), isPresented: $vm.uploadFailed){
                    Button("confirm".localizedString(language: language), role: .cancel) { vm.uploadFailed.toggle() }
                }
                .alert("saved_photo_msg".localizedString(language: language), isPresented: $vm.showSavedPhotoAlert){
                    Button("confirm".localizedString(language: language), role: .cancel) { vm.showSavedPhotoAlert.toggle() }
                }
            }
        }
    }
}
