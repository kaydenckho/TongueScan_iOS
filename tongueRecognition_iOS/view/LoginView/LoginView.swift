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
    
    enum InputType{
        case Email
        case Code
        case Password
        case Username
    }

    @Binding var state :PageState
    
    @State var inputType :InputType? = nil
    
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
    
    @State var passwordRule1 = false
    @State var passwordRule2 = false
    @State var passwordRule3 = false
    @State var passwordRule4 = false
    
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
                                    
                                        ZStack{
                                            HStack(){
                                                Button(action: {
                                                    if (state == .Login){
                                                        tabViewSelection = 0
                                                    } else{
                                                        state == .Login
                                                    }
                                                }){
                                                    Image(systemName:"chevron.left")
                                                        .foregroundColor(Color("indicator_grey"))
                                                }
                                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                                .buttonStyle(ClickScaleDown())
                                                Spacer()
                                            }
                                            
                                            HStack(){
                                                Spacer()
                                                switch state{
                                                case .Register:  
                                                    "memberRegister".localizedText(language: language)
                                                        .font(.headline)
                                                case .Login:
                                                    "memberLogin".localizedText(language: language)
                                                            .font(.headline)
                                                case .ForgetPassword:
                                                    "resetPassword".localizedText(language: language)
                                                            .font(.headline)
                                                default:
                                                    "memberLogin".localizedText(language: language)
                                                            .font(.headline)
                                                }
                                                Spacer()
                                            }
                                        }
                                        .padding([.bottom], 20)
                                        
                                        if (state != .Login){
                                            HStack{
                                                let text = (inputType == .Email) ? "inputEmail" : (inputType == .Code) ? "inputCode" : (inputType == .Username) ? "inputUsername" : (inputType == .Password && state == .Register) ? "createPassword" : "newPassword"
                                                text.localizedText(language: language)
                                                    .font(.headline).foregroundStyle(Color.black)
                                                Spacer()
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: (inputType == .Code || inputType == .Username) ? 5 : 20, trailing: 0))
                                        }
                                        
                                        if (state != .Login && inputType == .Code){
                                            HStack{
                                                ("inputCodeDescription".localizedText(language: language)
                                                    .font(.footnote).foregroundStyle(Color.black) +
                                                Text(email)
                                                    .font(.footnote).foregroundStyle(Color.black)
                                                )
                                                .fixedSize(horizontal: false, vertical: true)
                                                Spacer()
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 0))
                                        }
                                        
                                        if (state != .Login && inputType == .Username){
                                            HStack{
                                                "inputUsernameDescription".localizedText(language: language)
                                                    .font(.footnote).foregroundStyle(Color.black)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                Spacer()
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 0))
                                        }
                                        
                                        if (state == .Login || (state == .Register && inputType == .Username)){
                                            TextInputView(hint: "username".localizedString(language: language),input:$username, image:"person_icon")
                                                .cornerRadius(20.0)
                                                .focused($usernameIsFocused)
                                                .onTapGesture{
                                                    usernameIsFocused = true
                                                }
                                                .overlay(
                                                    usernameIsNotValid ?
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .stroke(.red, lineWidth: 2)
                                                    :
                                                        nil
                                                )
                                                .autocapitalization(.none)
                                                .padding(EdgeInsets(top: 0, leading: 20, bottom: (state == .Register) ? 5 : 15, trailing: 20))
                                        }
                                        
                                        if (state == .Register && inputType == .Username){
                                            HStack{
                                                "usernameRule".localizedText(language: language)
                                                    .font(.footnote).foregroundColor(Color("indicator_grey"))
                                                    .fixedSize(horizontal: false, vertical: true)
                                                Spacer()
                                                Text("\(username.count)/20")
                                                    .font(.footnote).foregroundColor((username.count > 20) ? Color.red : Color("indicator_grey"))
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                                        }
                                        
                                        
                                        if (state == .Login || ((state == .Register || state == .ForgetPassword) && inputType == .Password)){
                                            SecureTextInputView(hint: (state == .ForgetPassword) ? "newPassword".localizedString(language: language) :  "password".localizedString(language: language),input:$password, image:"password", isMasked:$passwordMask, onChangeAction: (state != .Login && inputType == .Password) ? {
                                                passwordRule1 = checkLength(password: password)
                                                passwordRule2 = hasUppercase(password: password)
                                                passwordRule3 = hasLowercase(password: password)
                                                passwordRule4 = hasSymbolOrNumber(password: password)
                                            } : {})
                                                .cornerRadius(20.0)
                                                .focused($passwordIsFocused)
                                                .onTapGesture{
                                                    passwordIsFocused = true
                                                }
                                                .overlay(
                                                    passwordIsNotValid ?
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(.red, lineWidth: 2)
                                                    :
                                                        nil
                                                )
                                                .autocapitalization(.none)
                                                .padding((state == .Register) ? EdgeInsets(top: 0, leading: 20, bottom: (state != .Login) ? 15 : 0, trailing: 20) : EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                                        }
                                        
                                        if (state != .Login && inputType == .Password){
                                            HStack{
                                                "inputPasswordDescription".localizedText(language: language)
                                                    .font(.footnote).foregroundColor(Color("indicator_grey"))
                                                    .fixedSize(horizontal: false, vertical: true)
                                                Spacer()
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                            HStack{
                                                Toggle(isOn: $passwordRule1){
                                                    "passwordRule1".localizedText(language: language)
                                                        .font(.caption).foregroundColor(Color("light_grey"))
                                                        .fixedSize(horizontal: false, vertical: true)
                                                }
                                                .allowsHitTesting(false)
                                                .toggleStyle(iOSCheckboxToggleStyle())
                                                .fixedSize(horizontal: false, vertical: true)
                                                Spacer()
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                            HStack{
                                                Toggle(isOn: $passwordRule2){
                                                    "passwordRule2".localizedText(language: language)
                                                        .font(.caption).foregroundColor(Color("light_grey"))
                                                        .fixedSize(horizontal: false, vertical: true)
                                                }
                                                .allowsHitTesting(false)
                                                .toggleStyle(iOSCheckboxToggleStyle())
                                                .fixedSize(horizontal: false, vertical: true)
                                                Spacer()
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                            HStack{
                                                Toggle(isOn: $passwordRule3){
                                                    "passwordRule3".localizedText(language: language)
                                                        .font(.caption).foregroundColor(Color("light_grey"))
                                                        .fixedSize(horizontal: false, vertical: true)
                                                }
                                                .allowsHitTesting(false)
                                                .toggleStyle(iOSCheckboxToggleStyle())
                                                .fixedSize(horizontal: false, vertical: true)
                                                Spacer()
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                            HStack{
                                                Toggle(isOn: $passwordRule4){
                                                    "passwordRule4".localizedText(language: language)
                                                        .font(.caption).foregroundColor(Color("light_grey"))
                                                        .fixedSize(horizontal: false, vertical: true)
                                                }
                                                .allowsHitTesting(false)
                                                .toggleStyle(iOSCheckboxToggleStyle())
                                                .fixedSize(horizontal: false, vertical: true)
                                                Spacer()
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 0))
                                    
                                        }
                                        
                                        if ((state == .Register || state == .ForgetPassword) && inputType == .Email){
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
                                                .autocapitalization(.none)
                                        }
                                            
                                        if ((state == .Register || state == .ForgetPassword) && inputType == .Code){
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
                                                    .autocapitalization(.none)
                                                
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
                                                    Button("confirm".localizedString(language: language), role: .cancel) { vm.sendCodeCompleted = false }
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
                                                    inputType = .Email
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
                                                handleLogin()
                                            } else if (state == .Register){
                                                handleRegister()
                                            } else if (state == .ForgetPassword){
                                                handleForgetPassword()
                                            }
                                        }){
                                            Button1View(text: (state == .Login) ? "login".localizedString(language: language) : ((state == .Register && inputType == .Username) || (state == .ForgetPassword && inputType == .Password)) ? "confirm".localizedString(language: language) : "next".localizedString(language: language)
                                                        , width: .infinity, color: Color("toolbarBackground"), topLeading:0, bottomLeading:20, topTrailing:20, bottomTrailing:20, verticalPadding:10, textSize: Font.headline, textColor:.white)
                                        }
                                        .padding(EdgeInsets(top: (state == .Login) ? 0 : 10, leading: 20, bottom: (state == .Register && inputType != .Email) || (state == .ForgetPassword) ? 40 : 15, trailing: 20))
                                        .buttonStyle(ClickScaleDown())
                                        
                                        if (state == .Register && inputType == .Email){
                                            (
                                                "registerEmailHint1".localizedText(language: language)
                                                    .font(.footnote)
                                                    .foregroundColor(Color("toolbarBackground")) +
                                                "registerEmailHint2".localizedText(language: language)
                                                    .font(.footnote)
                                                    .foregroundColor(Color("orange"))
                                            )
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .multilineTextAlignment(.center)
                                        }
                                        
                                        if (state == .Login){
                                            Button(action: {
                                                if (preferenceUtil.username != nil){
                                                    biometricAuth()
                                                } else{
                                                    biometricFirstTimeDialog = true
                                                }
                                            }){
                                                Button1View(text: "biometric_login".localizedString(language: language), width: .infinity, color: Color("toolbarBackground"), topLeading:0, bottomLeading:20, topTrailing:20, bottomTrailing:20, verticalPadding:10, textSize: Font.headline, textColor:.white)
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                                            .buttonStyle(ClickScaleDown())
                                        }
                                   
                                        if (state == .Login){
                                            HStack{
                                                "no_account".localizedText(language: language)
                                                    .font(.footnote)
                                                    .foregroundColor(Color("toolbarBackground"))
                                                Button(action: {
                                                    state = .Register
                                                    inputType = .Email
                                                }){
                                                    "register".localizedText(language: language)
                                                        .font(.footnote)
                                                        .foregroundColor(Color("orange"))
                                                }
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
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
                        .alert(vm.registerModel?.message ?? "network_error".localizedString(language: language), isPresented: $vm.registerCompleted){
                            Button("confirm".localizedString(language: language), role: .cancel) { vm.registerCompleted = false }
                        }
                    }
                    .alert(vm.sendCodeModel?.message ?? "network_error".localizedString(language: language), isPresented: $vm.sendCodeCompleted){
                        Button("confirm".localizedString(language: language), role: .cancel) { vm.sendCodeCompleted = false }
                    }
                    .alert(vm.verifyCodeModel?.message ?? "network_error".localizedString(language: language), isPresented: $vm.verifyCodeCompleted){
                        Button("confirm".localizedString(language: language), role: .cancel) { vm.verifyCodeCompleted = false }
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
                .alert(vm.loginModel?.message ?? "network_error".localizedString(language: language), isPresented: $vm.loginCompleted){
                    Button("confirm".localizedString(language: language), role: .cancel) { vm.loginCompleted = false }
                }
                .alert(vm.resetPasswordModel?.message ?? "network_error".localizedString(language: language), isPresented: $vm.resetPasswordCompleted){
                    Button("confirm".localizedString(language: language), role: .cancel) { vm.resetPasswordCompleted = false }
                }
            }
            .onReceive(sendCodeCountdownTimer){ _ in
                if (isStartCountdown && sendCodeCountdown > 0) {
                    sendCodeCountdown -= 1
                } else{
                    isStartCountdown = false
                    sendCodeCountdown = 60
                }
            }
            .alert("biometric_not_supported".localizedString(language: language), isPresented: $biometricNotSupportedDialog){
                Button("confirm".localizedString(language: language), role: .cancel) { biometricNotSupportedDialog = false }
            }
            .alert("biometric_first_time".localizedString(language: language), isPresented: $biometricFirstTimeDialog){
                Button("confirm".localizedString(language: language), role: .cancel) { biometricFirstTimeDialog = false }
            }
            .onAppear(){
                clearData()
                state = .Login
                isRememberLogin = true
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
    
    func checkLength(password:String) -> Bool{
        return (8...30).contains(password.count)
    }
    
    func hasUppercase(password:String) -> Bool{
        let letters = NSCharacterSet.uppercaseLetters
        let range = password.rangeOfCharacter(from: letters)
        if let test = range {
            return true
        }
        else {
            return false
        }
    }
    
    func hasLowercase(password:String) -> Bool{
        let letters = NSCharacterSet.lowercaseLetters
        let range = password.rangeOfCharacter(from: letters)
        if let test = range {
            return true
        }
        else {
            return false
        }
    }
    
    func hasSymbolOrNumber(password: String) -> Bool{
        let letters = NSCharacterSet.symbols
        let range = password.rangeOfCharacter(from: letters)
        if let test = range {
            return true
        }
        else {
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
    
    func handleLogin(){
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
                    clearData()
                    state = .LoggedIn
                })
            }
        }
    }
    
    func handleRegister(){
        switch inputType {
            case .Email:
                if (!email.isEmpty){
                    Task{
                        await vm.sendCode(email: email) {
                            inputType = .Code
                            vm.sessionId = vm.sendCodeModel?.data?.session_id ?? ""
                            if (!isStartCountdown){
                                isStartCountdown = true
                            }
                        }
                    }
                } else{
                    emailIsNotValid = true
                }
            case .Code:
                if (!code.isEmpty){
                    Task{
                        await vm.verifyCode(code: code, sessionId: vm.sessionId, callback: {inputType = .Password
                        })
                    }
                } else{
                    codeIsEmpty = true
                }
            case .Password:
                if (!password.isEmpty && checkPasswordValid(password: password)){
                    inputType = .Username
                } else{
                    passwordIsNotValid = true
                }
            case .Username:
                if (!username.isEmpty && checkUsernameValid(username: username)){
                    Task{
                        await vm.register(username: username, password: password, email: email, code: code, sessionId: vm.sessionId, callback:{
                            let loginModel = LoginModel(message: vm.registerModel?.message , token: vm.registerModel?.data?.token, username: vm.registerModel?.data?.username)
                            tongueRecognition_iOSApp.loginModel = loginModel
                            preferenceUtil.username = loginModel.username
                            preferenceUtil.token = loginModel.token
                            clearData()
                            state = .LoggedIn
                        })
                    }
                } else{
                    usernameIsNotValid = true
                }
        default: ()
            
        }
    }
    
    func handleForgetPassword(){
        switch inputType {
            case .Email:
                if (!email.isEmpty){
                    Task{
                        await vm.sendForgetPasswordCode(email: email) {
                            inputType = .Code
                            vm.sessionId = vm.sendCodeModel?.data?.session_id ?? ""
                            if (!isStartCountdown){
                                isStartCountdown = true
                            }
                        }
                    }
                } else{
                    emailIsNotValid = true
                }
            case .Code:
                if (!code.isEmpty){
                    Task{
                        await vm.verifyCode(code: code, sessionId: vm.sessionId, callback: {
                            inputType = .Password
                        })
                    }
                } else{
                    codeIsEmpty = true
                }
            case .Password:
                if (!password.isEmpty && checkPasswordValid(password: password)){
                    Task{
                        await vm.resetPassword(password: password, email: email, code: code, sessionId: vm.sessionId, callback:{
                            clearData()
                            state = .Login
                        })
                    }
                } else{
                    passwordIsNotValid = true
                }
            case .Username: ()
        default: ()
            
        }
    }
    
    func clearData(){
        username = ""
        password = ""
        confirmPassword = ""
        email = ""
        code = ""
    }

}

