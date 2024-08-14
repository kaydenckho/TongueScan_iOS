//
//  Webservice].swift
//  tongueRecognition_iOS
//
//  Created by user on 2023/6/12.
//

import Foundation
import Alamofire


struct Webservice {
    
    enum NetworkError: Error {
        case statusError(reason:String)
    }
    
    func uploadImage(imageArray:[ImageModel], language:String, token: String, completion: @escaping (Result<APIResponse<UploadImagesResult>?>) -> Void){
        if !imageArray.isEmpty{
            Alamofire.upload(multipartFormData: { multipartFormData in
                for image in imageArray{
                    if let data = image.croppedImg{
                        if (image.filename.contains("flash")){
                            multipartFormData.append(data,withName:"flash",fileName:image.filename,mimeType: "image/png")
                        } else{
                            multipartFormData.append(data,withName:"raw",fileName:image.filename,mimeType: "image/png")
                        }
                    }
                }
                multipartFormData.append(language.data(using: .utf8)!,withName:"language",mimeType: "text/plain")
                multipartFormData.append(token.data(using: .utf8)!,withName:"token",mimeType: "text/plain")
            },to:Constant.BASE_URL+Constant.TONGUE_RESULT)
            { (result) in
                print(result)
                switch result {
                case .success(let upload, _, _):
                    //                    upload.uploadProgress(closure: { (progress) in
                    //                        print("Upload Progress: \(progress.fractionCompleted)")
                    //                    })
                    var model = APIResponse<UploadImagesResult>()
                    upload.responseJSON { response in
                        print(response)
                        do{
                            if let data = response.data{
                                let decoder = JSONDecoder()
                                model = try decoder.decode(APIResponse<UploadImagesResult>.self, from: data)
                            }
                        } catch {
                            print(error)
                            completion(.failure(error))
                        }
                        completion(.success(model))
                    }
                case .failure(let encodingError):
                    completion(.failure(encodingError))
                }
            }
        }
        
    }
    
    func login(username:String, password:String, completion: @escaping (Result<APIResponse<LoginModel>?>) -> Void){
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(username.data(using: .utf8)!,withName:"username_or_email",mimeType: "text/plain")
            multipartFormData.append(password.data(using: .utf8)!,withName:"password",mimeType: "text/plain")
        },to:Constant.BASE_URL+Constant.LOGIN)
        { (result) in
            print(result)
            switch result {
            case .success(let upload, _, _):
                //                    upload.uploadProgress(closure: { (progress) in
                //                        print("Upload Progress: \(progress.fractionCompleted)")
                //                    })
                var model = APIResponse<LoginModel>()
                upload.responseJSON { response in
                    do{
                        if let data = response.data{
                            let decoder = JSONDecoder()
                            model = try decoder.decode(APIResponse<LoginModel>.self, from: data)
                        }
                        print(model)
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                    completion(.success(model))
                }
            case .failure(let encodingError):
                completion(.failure(encodingError))
            }
        }
    }
    
    func register(username:String, password:String, email:String, code:String, sessionId:String, completion: @escaping (Result<APIResponse<RegisterModel>?>) -> Void){
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(username.data(using: .utf8)!,withName:"username",mimeType: "text/plain")
            multipartFormData.append(password.data(using: .utf8)!,withName:"password",mimeType: "text/plain")
            multipartFormData.append(email.data(using: .utf8)!,withName:"email",mimeType: "text/plain")
            multipartFormData.append(code.data(using: .utf8)!,withName:"code",mimeType: "text/plain")
            multipartFormData.append(sessionId.data(using: .utf8)!,withName:"session_id",mimeType: "text/plain")
        },to:Constant.BASE_URL+Constant.REGISTER)
        { (result) in
            print(result)
            switch result {
            case .success(let upload, _, _):
                //                    upload.uploadProgress(closure: { (progress) in
                //                        print("Upload Progress: \(progress.fractionCompleted)")
                //                    })
                var model = APIResponse<RegisterModel>()
                upload.responseJSON { response in
                    do{
                        if let data = response.data{
                            let decoder = JSONDecoder()
                            model = try decoder.decode(APIResponse<RegisterModel>.self, from: data)
                        }
                        print(model)
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                    completion(.success(model))
                }
            case .failure(let encodingError):
                completion(.failure(encodingError))
            }
        }
    }
    
    func obtainEmailRegisterCode(email:String, completion: @escaping (Result<APIResponse<RegisterModel>?>) -> Void){
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(email.data(using: .utf8)!,withName:"email",mimeType: "text/plain")
        },to:Constant.BASE_URL+Constant.OBTAIN_EMAIL_REGISTER_CODE)
        { (result) in
            print(result)
            switch result {
            case .success(let upload, _, _):
                //                    upload.uploadProgress(closure: { (progress) in
                //                        print("Upload Progress: \(progress.fractionCompleted)")
                //                    })
                var model = APIResponse<RegisterModel>()
                upload.responseJSON { response in
                    do{
                        if let data = response.data{
                            let decoder = JSONDecoder()
                            model = try decoder.decode(APIResponse<RegisterModel>.self, from: data)
                        }
                        print(model)
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                    completion(.success(model))
                }
            case .failure(let encodingError):
                completion(.failure(encodingError))
            }
        }
    }
    
    func obtainForgetPasswordCode(email:String, completion: @escaping (Result<APIResponse<RegisterModel>?>) -> Void){
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(email.data(using: .utf8)!,withName:"email",mimeType: "text/plain")
        },to:Constant.BASE_URL+Constant.OBTAIN_EMAIL_FORGET_PASSWORD_CODE)
        { (result) in
            print(result)
            switch result {
            case .success(let upload, _, _):
                //                    upload.uploadProgress(closure: { (progress) in
                //                        print("Upload Progress: \(progress.fractionCompleted)")
                //                    })
                var model = APIResponse<RegisterModel>()
                upload.responseJSON { response in
                    do{
                        if let data = response.data{
                            let decoder = JSONDecoder()
                            model = try decoder.decode(APIResponse<RegisterModel>.self, from: data)
                        }
                        print(model)
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                    completion(.success(model))
                }
            case .failure(let encodingError):
                completion(.failure(encodingError))
            }
        }
    }
    
    func resetPassword(password:String, email: String, code: String, sessionId: String, completion: @escaping (Result<APIResponse<RegisterModel>?>) -> Void){
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(password.data(using: .utf8)!,withName:"password",mimeType: "text/plain")
                multipartFormData.append(email.data(using: .utf8)!,withName:"email",mimeType: "text/plain")
                multipartFormData.append(code.data(using: .utf8)!,withName:"code",mimeType: "text/plain")
                multipartFormData.append(sessionId.data(using: .utf8)!,withName:"session_id",mimeType: "text/plain")
            },to:Constant.BASE_URL+Constant.RESET_PASSWORD)
            { (result) in
                print(result)
                switch result {
                case .success(let upload, _, _):
                    //                    upload.uploadProgress(closure: { (progress) in
                    //                        print("Upload Progress: \(progress.fractionCompleted)")
                    //                    })
                    var model = APIResponse<RegisterModel>()
                    upload.responseJSON { response in
                        do{
                            if let data = response.data{
                                let decoder = JSONDecoder()
                                model = try decoder.decode(APIResponse<RegisterModel>.self, from: data)
                            }
                            print(model)
                        } catch {
                            print(error)
                            completion(.failure(error))
                        }
                        completion(.success(model))
                    }
                case .failure(let encodingError):
                    completion(.failure(encodingError))
                }
            }
        }
    
    func verifyCode(code:String, sessionId: String, completion: @escaping (Result<APIResponse<RegisterModel>?>) -> Void){
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(code.data(using: .utf8)!,withName:"code",mimeType: "text/plain")
                multipartFormData.append(sessionId.data(using: .utf8)!,withName:"session_id",mimeType: "text/plain")
            },to:Constant.BASE_URL+Constant.REGISTER_VERIFY_CODE)
            { (result) in
                print(result)
                switch result {
                case .success(let upload, _, _):
                    //                    upload.uploadProgress(closure: { (progress) in
                    //                        print("Upload Progress: \(progress.fractionCompleted)")
                    //                    })
                    var model = APIResponse<RegisterModel>()
                    upload.responseJSON { response in
                        do{
                            if let data = response.data{
                                let decoder = JSONDecoder()
                                model = try decoder.decode(APIResponse<RegisterModel>.self, from: data)
                            }
                            print(model)
                        } catch {
                            print(error)
                            completion(.failure(error))
                        }
                        completion(.success(model))
                    }
                case .failure(let encodingError):
                    completion(.failure(encodingError))
                }
            }
        }
}

