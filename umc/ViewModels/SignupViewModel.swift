//
//  SignupViewModel.swift
//  umc
//
//  Created by json on 3/28/25.
//

import SwiftUI

//class SignupViewModel: ObservableObject {
//    @AppStorage("nickname") private var storedNickname: String = ""
//    @AppStorage("email") private var storedEmail: String = ""
//    @AppStorage("password") private var storedPassword: String = ""
//    
//    @Published var signupModel = SignupModel(nickname: "", email: "", password: "")
//    
//    func saveUserData() {
//        storedNickname = signupModel.nickname
//        storedEmail = signupModel.email
//        storedPassword = signupModel.password
//    }
//}
class SignupViewModel: ObservableObject {
    @Published var signupModel = SignupModel()
    
    @AppStorage("nickname") private var storedNickname: String = ""
    @AppStorage("email")    private var storedEmail: String    = ""
    @AppStorage("password") private var storedPassword: String = ""
    
    func saveUserData() {
        storedNickname = signupModel.nickname
        storedEmail = signupModel.email
        storedPassword = signupModel.password
    }
}
