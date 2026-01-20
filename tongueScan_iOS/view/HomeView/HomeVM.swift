//
//  HomeVM.swift
//  tongueScan_iOS
//
//  Created by user on 2023/6/14.
//

import Foundation
import Combine

class HomeVM: ObservableObject {
    
    @Published var uploading: Bool = false
    
    @Published var userInfoModel: APIResponse<LoginModel>?
    @Published var userInfoCompleted: Bool = false
    
    func userInfo(token:String, onSuccess: @escaping ()->Void, onFailure: @escaping ()->Void) async {
        DispatchQueue.main.async {
            self.uploading = true
        }
        Webservice().userInfo(token:token){ result in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    self.userInfoModel = model
                    if (model?.code == 0){
                        onSuccess()
                    } else{
                        onFailure()
                    }
                    //                        self.userInfoCompleted = true
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.userInfoModel = nil
                }
                self.userInfoCompleted = true
            }
            DispatchQueue.main.async {
                self.uploading = false
            }
        }
    }
    
}
