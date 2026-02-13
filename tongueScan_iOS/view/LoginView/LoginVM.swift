import Foundation
import Combine

class LoginVM: ObservableObject {
    
    @Published var uploading: Bool = false
    
    @Published var loginModel: APIResponse<LoginModel>?
    @Published var loginCompleted: Bool = false
    
    @Published var registerModel: APIResponse<RegisterModel>?
    @Published var registerCompleted: Bool = false
    
    @Published var sendCodeModel: APIResponse<RegisterModel>?
    @Published var sendCodeCompleted: Bool = false
    
    @Published var resetPasswordModel: APIResponse<RegisterModel>?
    @Published var resetPasswordCompleted: Bool = false
    
    @Published var verifyCodeModel: APIResponse<RegisterModel>?
    @Published var verifyCodeCompleted: Bool = false
    
    var sessionId:String = ""
    
    func login(username:String, password:String, callback: @escaping ()->Void) async {
        DispatchQueue.main.async {
            self.uploading = true
        }
        Webservice().login(username:username, password:password){ result in
                switch result{
                case .success(let model):
                    DispatchQueue.main.async {
                        self.loginModel = model
                        if (model?.code == 0){
                            callback()
                        }
//                        self.loginCompleted = true
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.loginModel = nil
                    }
                    self.loginCompleted = true
                }
            DispatchQueue.main.async {
                self.uploading = false
            }
        }
    }
    
    func register(username:String, password:String, email:String, code:String, sessionId:String, callback: @escaping ()->Void) async {
        DispatchQueue.main.async {
            self.uploading = true
        }
        Webservice().register(username:username, password:password, email:email, code:code, sessionId:sessionId){ result in
                switch result{
                case .success(let model):
                        DispatchQueue.main.async {
                            self.registerModel = model
                            if (model?.code == 0){
                                callback()
                            }
                            self.registerCompleted = true
                        }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.registerModel = nil
                    }
                    self.registerCompleted = true
                }
            DispatchQueue.main.async {
                self.uploading = false
            }
        }
    }
    
    func sendCode(email:String, callback: @escaping ()->Void) async {
        DispatchQueue.main.async {
            self.uploading = true
        }
        Webservice().obtainEmailRegisterCode(email: email){ result in
                switch result{
                case .success(let model):
                    DispatchQueue.main.async {
                        self.sendCodeModel = model
                        if (model?.code == 0){
                            callback()
                        } else{
                            self.sendCodeCompleted = true
                        }
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.sendCodeModel = nil
                    }
                    self.sendCodeCompleted = true
                }
                    
            DispatchQueue.main.async {
                self.uploading = false
            }
        }
    }
    
    func sendForgetPasswordCode(email:String, callback: @escaping ()->Void) async {
        DispatchQueue.main.async {
            self.uploading = true
        }
        Webservice().obtainForgetPasswordCode(email: email){ result in
                switch result{
                case .success(let model):
                    DispatchQueue.main.async {
                        self.sendCodeModel = model
                        if (model?.code == 0){
                            callback()
                        }
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.sendCodeModel = nil
                    }
                    self.sendCodeCompleted = true
                }
                    
            DispatchQueue.main.async {
                self.uploading = false
            }
        }
    }
    
    func resetPassword(password:String, email: String, code: String, sessionId: String, callback: @escaping ()->Void) async {
        DispatchQueue.main.async {
            self.uploading = true
        }
        Webservice().resetPassword(password: password, email: email, code: code, sessionId: sessionId){ result in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    self.resetPasswordModel = model
                    if (model?.code == 0){
                        callback()
                    }
                    self.resetPasswordCompleted = true
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.resetPasswordModel = nil
                }
                self.resetPasswordCompleted = true
            }
            DispatchQueue.main.async {
                self.uploading = false
            }
        }
    }
    
    func verifyCode(code: String, sessionId: String, callback: @escaping ()->Void) async {
        DispatchQueue.main.async {
            self.uploading = true
        }
        Webservice().verifyCode(code: code, sessionId: sessionId){ result in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    self.verifyCodeModel = model
                    if (model?.code == 0){
                        callback()
                    } else{
                        self.verifyCodeCompleted = true
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.verifyCodeModel = nil
                }
                self.verifyCodeCompleted = true
            }
            DispatchQueue.main.async {
                self.uploading = false
            }
        }
    }
}
