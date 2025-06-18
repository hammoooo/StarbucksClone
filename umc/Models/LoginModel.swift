//
//  LoginModel.swift
//  umc
//
//  Created by json on 3/28/25.
//

import Foundation


struct LoginModel {
    var id: String
    var pwd: String
    
   
    init(id: String, pwd: String) {
        self.id = id
        self.pwd = pwd
    }
    
   
    func isValid() -> Bool {
        return !id.isEmpty && !pwd.isEmpty
    }
}
