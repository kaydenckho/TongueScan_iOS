import SwiftUI
import LocalAuthentication

struct LoginView: View {
    
    @Environment(PreferenceUtil.self) var preferenceUtil
    
    @Binding var language : String?
    
    @StateObject private var vm = LoginVM()
    
    @Binding var isLoading:Bool
    
    @Binding var tabViewSelection:Int
    
    enum PageState {
        case Login
        case Register
        case ForgetPassword
        case LoggedIn
    }

    @Binding var state :PageState
    
    @State var username: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var email: String = ""
    @State var code: String = ""
    
    @State var usernameIsNotValid: Bool = false
    @State var passwordIsNotValid: Bool = false
    @State var confirmpasswordIsNotValid: Bool = false
    @State var emailIsNotValid: Bool = false
    @State var codeIsEmpty: Bool = false
    
    @State var isRememberLogin = false
    
    @State var passwordMask: Bool = true
    @State var confirmPasswordMask: Bool = true
    
    @FocusState private var usernameIsFocused: Bool
    @FocusState private var passwordIsFocused: Bool
    @FocusState private var confirmPasswordIsFocused: Bool
    @FocusState private var emailIsFocused: Bool
    @FocusState private var codeIsFocused: Bool
    
    @State private var keyboardHeight: CGFloat = 0
    
    @State private var sendCodeCountdown = 60
    @State private var isStartCountdown = false
    let sendCodeCountdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var biometricNotSupportedDialog = false
    @State var biometricFirstTimeDialog = false
    
    var body: some View {
        if (state == .LoggedIn){
            PersonalInfoView(language: $language, state: $state)
        } else{
            NavigationStack {
                ZStack {
                    GeometryReader{ geometry in
                        Image("index_topbar_bg")
                            .resizable()
                            .ignoresSafeArea()
                            .frame(height: geometry.size.height*0.35)
                        HStack{
                            Spacer()
                            VStack(){
                                Image("index_topbar_icon")
                                        .resizable().scaledToFit()
                                        .frame(width: 100)
                                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                                    VStack {
                                        HStack {
                                            Spacer()
                                            HStack (alignment: .center){
                                                Button(action: {
                                                    preferenceUtil.language = "zh-Hans"
                                                    language = "zh-Hans"
                                                }){
                                                    Text("简").foregroundColor(Color("toolbarBackground"))
                                                        .fontWeight(.semibold)
                                                        .font(.footnote)
                                                        .frame(alignment: .center)
                                                }
                                                Text("|").foregroundColor(Color("toolbarBackground")).offset(y:-1)
                                                    .fontWeight(.medium)
                                                    .font(.footnote)
                                                Button(action: {
                                                    preferenceUtil.language = "zh-HK"
                                                    language = "zh-HK"
                                                }){
                                                    Text("繁").foregroundColor(Color("toolbarBackground"))
                                                        .fontWeight(.semibold)
                                                        .frame(alignment: .center)
                                                        .font(.footnote)
                                                }
                                                Text("|").foregroundColor(Color("toolbarBackground")).offset(y:-1)
                                                    .fontWeight(.medium)
                                                Button(action: {
                                                    preferenceUtil.language = "en"
                                                    language = "en"
                                                }){
                                                    Text("ENG").foregroundColor(Color("toolbarBackground"))
                                                        .fontWeight(.medium)
                                                        .font(.footnote)
                                                }
                                            }
                                            Spacer()
                                        }
                                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 15, trailing: 0))
                                        HStack(){
                                            Spacer()
                                            Button(action: {
                                                state = .Login
                                            }){
                                                Button1View(text: "memberLogin".localizedString(language: language), width: .infinity, color: (state == .Login) ? Color("toolbarBackground") : Color("login_button_bg_grey"), topLeading:0, bottomLeading:20, topTrailing:20, bottomTrailing:20, verticalPadding:10, textSize: Font.headline, textColor:(state == .Login) ? Color.white : Color("login_button_text_grey"))
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5))
                                            .buttonStyle(ClickScaleDown())
                                            
                                            Button(action: {
                                                state = .Register
                                            }){
                                                Button1View(text: "memberRegister".localizedString(language: language), width: .infinity, color: (state == .Register) ? Color("toolbarBackground") : Color("login_button_bg_grey"), topLeading:20, bottomLeading:20, topTrailing:20, bottomTrailing:0, verticalPadding:10,textSize: Font.headline, textColor:(state == .Register) ? Color.white : Color("login_button_text_grey"))
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 10))
                                            .buttonStyle(ClickScaleDown())
                                            Spacer()
                                        }
                                        .padding([.bottom], 20)
                                        
                                        if (state != .ForgetPassword){
                                            TextInputView(hint: "username".localizedString(language: language),input:$username, image:"person_icon")
                                                .cornerRadius(20.0)
                                                .focused($usernameIsFocused)
                                                .padding((state == .Register) ? EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20) : EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                                                .onTapGesture{
                                                    usernameIsFocused = true
                                                }
                                                .overlay(
                                                    usernameIsNotValid ?
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .stroke(.red, lineWidth: 2)
                                                            .padding((state == .Register) ? EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20) : EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                                                    :
                                                        nil
                                                )
                                        }
                                        
                                        
                                        
                                        if (state == .Register){
                                            HStack{
                                                "username_invalid".localizedText(language: language)
                                                    .font(.caption2).foregroundStyle(Color.gray)
                                                    .padding(EdgeInsets(top: 0, leading: 25, bottom: 15, trailing: 25))
                                                    .fixedSize(horizontal: false, vertical: true)
                                                Spacer()
                                            }
                                        }
                                        
                                        SecureTextInputView(hint: (state == .ForgetPassword) ? "newPassword".localizedString(language: language) :  "password".localizedString(language: language),input:$password, image:"password", isMasked:$passwordMask)
                                            .cornerRadius(20.0)
                                            .focused($passwordIsFocused)
                                            .padding((state == .Register) ? EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20) : EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                                            .onTapGesture{
                                                passwordIsFocused = true
                                            }
                                            .overlay(
                                                passwordIsNotValid ?
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(.red, lineWidth: 2)
                                                        .padding((state == .Register) ? EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20) : EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                                                :
                                                    nil
                                            )
                                        
                                        if (state == .Register){
                                            HStack{
                                                "password_invalid".localizedText(language: language)
                                                    .font(.caption2).foregroundStyle(Color.gray)
                                                    .padding(EdgeInsets(top: 0, leading: 25, bottom: 15, trailing: 25))
                                                    .fixedSize(horizontal: false, vertical: true)
                                                Spacer()
                                            }
                                        }
                                        
                                        if (state == .Register){
                                            
                                            SecureTextInputView(hint: "confirm_password".localizedString(language: language),input:$confirmPassword, image:"password", isMasked:$confirmPasswordMask)
                                                .cornerRadius(20.0)
                                                .focused($confirmPasswordIsFocused)
                                                .padding((confirmpasswordIsNotValid) ? EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20) : EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                                                .onTapGesture{
                                                    confirmPasswordIsFocused = true
                                                }
                                                .overlay(
                                                    confirmpasswordIsNotValid ?
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(.red, lineWidth: 2)
                                                        .padding((confirmpasswordIsNotValid) ? EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20) : EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                                                    :
                                                        nil
                                                )
                                        }
                                            
                                            if (state == .Register && confirmpasswordIsNotValid){
                                                HStack(){
                                                    "passwordNotMatched".localizedText(language: language)
                                                        .font(.caption2).foregroundStyle(Color.red)
                                                        .padding(EdgeInsets(top: 0, leading: 25, bottom: 15, trailing: 25))
                                                        .fixedSize(horizontal: false, vertical: true)
                                                    Spacer()
                                                }
                                            }
                                            
                                        if (state == .Register || state == .ForgetPassword){
                                            TextInputView(hint: "email".localizedString(language: language),input:$email, image:"person_icon")
                                                .cornerRadius(20.0)
                                                .focused($emailIsFocused)
                                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                                                .onTapGesture{
                                                    emailIsFocused = true
                                                }
                                                .overlay(
                                                    emailIsNotValid ?
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(.red, lineWidth: 2)
                                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                                                    :
                                                        nil
                                                )
                                            
                                            HStack(spacing:0){
                                                TextInputView(hint: "verification_code".localizedString(language: language),input:$code, image:"code")
                                                    .focused($codeIsFocused)
                                                    .clipShape(
                                                        .rect(
                                                            topLeadingRadius: 20,
                                                            bottomLeadingRadius: 20,
                                                            bottomTrailingRadius: 0,
                                                            topTrailingRadius: 0
                                                        )
                                                    )
                                                    .onTapGesture{
                                                        codeIsFocused = true
                                                    }
                                                
                                                Button(action: {
                                                    emailIsNotValid = false
                                                    usernameIsFocused = false
                                                    passwordIsFocused = false
                                                    confirmPasswordIsFocused = false
                                                    emailIsFocused = false
                                                    codeIsFocused = false
                                                    if (email.isEmpty){
                                                        emailIsNotValid = true
                                                    } else{
                                                        if (!isStartCountdown){
                                                            Task{
                                                                if (state == .Register){
                                                                    await vm.sendCode(email: email, callback: {
                                                                        vm.sessionId = vm.sendCodeModel?.data?.session_id ?? ""
                                                                        if (!isStartCountdown){
                                                                            isStartCountdown = true
                                                                        }
                                                                    })
                                                                } else{
                                                                    await vm.sendForgetPasswordCode(email: email, callback: {
                                                                        vm.sessionId = vm.sendCodeModel?.data?.session_id ?? ""
                                                                        if (!isStartCountdown){
                                                                            isStartCountdown = true
                                                                        }
                                                                    })
                                                                }
                                                            }
                                                        }
                                                    }
                                                }){
                                                    Button1View(text: isStartCountdown ? "\(sendCodeCountdown)s" : "send_verification_code".localizedString(language: language), width: 100, color: isStartCountdown ? Color.gray : Color("toolbarBackground"), topLeading:0, bottomLeading:0, topTrailing:20, bottomTrailing:20, verticalPadding:15, textSize: .footnote, textColor:.white)
                                                }
                                                .buttonStyle(ClickScaleDown())
                                                .alert(vm.sendCodeModel?.message ?? "network_error".localizedString(language: language), isPresented: $vm.sendCodeCompleted){
                                                    Button("confirm", role: .cancel) { vm.sendCodeCompleted = false }
                                                }
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                                            .overlay(
                                                codeIsEmpty ?
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(.red, lineWidth: 2)
                                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                                                :
                                                    nil
                                            )
                                        }
                                        
                                        
                                        if (state == .Login){
                                            HStack{
                                                Toggle(isOn: $isRememberLogin) {
                                                    "rememberLogin".localizedText(language: language)
                                                        .font(.footnote)
                                                }
                                                .toggleStyle(iOSCheckboxToggleStyle())
                                                .padding(EdgeInsets(top: 0, leading: 25, bottom: 15, trailing: 0))
                                                .fixedSize(horizontal: false, vertical: true)
                                                Spacer()
                                                Button(action: {
                                                    state = .ForgetPassword
                                                }){
                                                    "forgetPassword".localizedText(language: language)
                                                        .font(.footnote).foregroundStyle(Color.gray)
                                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 25))
                                                        .fixedSize(horizontal: false, vertical: true)
                                                }
                                                .buttonStyle(ClickScaleDown())
                                            }
                                        }
                                        
                                        Button(action: {
                                            usernameIsFocused = false
                                            passwordIsFocused = false
                                            confirmPasswordIsFocused = false
                                            emailIsFocused = false
                                            codeIsFocused = false
                                            usernameIsNotValid = false
                                            passwordIsNotValid = false
                                            confirmpasswordIsNotValid = false
                                            emailIsNotValid = false
                                            codeIsEmpty = false
                                            if (state == .Login){
                                                if (username.isEmpty){
                                                   usernameIsNotValid = true
                                                } else if (password.isEmpty){
                                                    passwordIsNotValid = true
                                                } else{
                                                    Task{
                                                        await vm.login(username: username, password: password, callback:{
                                                            tongueRecognition_iOSApp.loginModel = vm.loginModel?.data
                                                            preferenceUtil.username = vm.loginModel?.data?.username
                                                            preferenceUtil.token = vm.loginModel?.data?.token
                                                            preferenceUtil.isRememberLogin = self.isRememberLogin
                                                            state = .LoggedIn
                                                        })
                                                    }
                                                }
                                            } else if (state == .Register){
                                                if (username.isEmpty || !checkUsernameValid(username: username)){
                                                   usernameIsNotValid = true
                                                } else if (password.isEmpty || !checkPasswordValid(password: password)){
                                                    passwordIsNotValid = true
                                                } else if (confirmPassword.isEmpty || (password != confirmPassword) ){
                                                    confirmpasswordIsNotValid = true
                                                } else if (email.isEmpty){
                                                    emailIsNotValid = true
                                                } else if (code.isEmpty){
                                                    codeIsEmpty = true
                                                } else{
                                                    Task{
                                                        await vm.register(username: username, password: password, email: email, code: code, sessionId: vm.sessionId, callback:{
                                                        })
                                                    }
                                                }
                                            } else if (state == .ForgetPassword){
                                                if (password.isEmpty || !checkPasswordValid(password: password)){
                                                    passwordIsNotValid = true
                                                } else if (email.isEmpty){
                                                    emailIsNotValid = true
                                                } else if (code.isEmpty){
                                                    codeIsEmpty = true
                                                } else{
                                                    Task{
                                                        await vm.resetPassword(password: password, email: email, code: code, sessionId: vm.sessionId, callback:{
                                                        })
                                                    }
                                                }
                                            }
                                        }){
                                            Button1View(text: state == .Login ? "login".localizedString(language: language) : state == .Register ? "register".localizedString(language: language) : "resetPassword".localizedString(language: language), width: .infinity, color: Color("toolbarBackground"), topLeading:0, bottomLeading:20, topTrailing:20, bottomTrailing:20, verticalPadding:10, textSize: Font.headline, textColor:.white)
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                                        .buttonStyle(ClickScaleDown())
                                        
                                        Button(action: {
                                            if (preferenceUtil.username != nil){
                                                biometricAuth()
                                            } else{
                                                biometricFirstTimeDialog = true
                                            }
                                        }){
                                            Button1View(text: "biometric_login".localizedString(language: language), width: .infinity, color: Color("toolbarBackground"), topLeading:0, bottomLeading:20, topTrailing:20, bottomTrailing:20, verticalPadding:10, textSize: Font.headline, textColor:.white)
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 30, trailing: 20))
                                        .buttonStyle(ClickScaleDown())
                                        .alert(vm.loginModel?.message ?? "network_error".localizedString(language: language), isPresented: $vm.loginCompleted){
                                            Button("confirm", role: .cancel) { vm.loginCompleted = false }
                                        }
                                        .alert(vm.registerModel?.message ?? "network_error".localizedString(language: language), isPresented: $vm.registerCompleted){
                                            Button("confirm", role: .cancel) { vm.registerCompleted = false }
                                        }
                                        .alert(vm.resetPasswordModel?.message ?? "network_error".localizedString(language: language), isPresented: $vm.resetPasswordCompleted){
                                            Button("confirm", role: .cancel) { vm.resetPasswordCompleted = false }
                                        }
                                        .alert("biometric_not_supported".localizedString(language: language), isPresented: $biometricNotSupportedDialog){
                                            Button("confirm", role: .cancel) { biometricNotSupportedDialog = false }
                                        }
                                        .alert("biometric_first_time".localizedString(language: language), isPresented: $biometricFirstTimeDialog){
                                            Button("confirm", role: .cancel) { biometricFirstTimeDialog = false }
                                        }
                             
                                        
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .stroke(Color("toolbarBackground"), lineWidth: 4)
                                    )
                                    .background(.white)
                                    .cornerRadius(20)
                                    .shadow(color: Color("cardBackground"), radius: 1.5, x: 0, y: 1.5)
                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    LoadingView(text:"loading".localizedString(language: language)).opacity(vm.uploading ? 1 : 0)
                }
                .onTapGesture {
                    usernameIsFocused = false
                    passwordIsFocused = false
                    confirmPasswordIsFocused = false
                    emailIsFocused = false
                    codeIsFocused = false
                }
                .ignoresSafeArea(.keyboard)
                .keyboardHeight($keyboardHeight)
                .animation(.easeOut(duration: 0.16))
                .offset(y: state == .Login ? 0 : (-keyboardHeight / 2.5))
            }
            .onReceive(sendCodeCountdownTimer){ _ in
                if (isStartCountdown && sendCodeCountdown > 0) {
                    sendCodeCountdown -= 1
                } else{
                    isStartCountdown = false
                    sendCodeCountdown = 60
                }
            }
        }
    }
    
    func checkUsernameValid(username:String) -> Bool{
        do {
            let usernameRegex = try Regex("^[a-zA-Z0-9._]{5,20}$")
            return username.contains(usernameRegex)
        } catch{
            return false
        }
    }
    
    func checkPasswordValid(password:String) -> Bool{
        do {
            let passwordRegex = try Regex("^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[\\da-zA-Z!@#$%^&*.]{8,30}$")
            return password.contains(passwordRegex)
        } catch{
            return false
        }
    }
    
    func biometricAuth() {
        let context = LAContext()
        var error: NSError?
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "biometric_description".localizedString(language: language)
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    // authenticated successfully
                    preferenceUtil.isRememberLogin = self.isRememberLogin
                    tongueRecognition_iOSApp.loginModel = LoginModel(token: preferenceUtil.token, username: preferenceUtil.username)
                    state = .LoggedIn
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
            biometricNotSupportedDialog = true
        }
    }

}

