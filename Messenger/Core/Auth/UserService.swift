//
//  UserService.swift
//  Messenger
//
//  Created by Ujjwal Arora on 22/09/24.
//

import Foundation
import FirebaseAuth

class UserService{
    func authSignUp(email : String, password : String) async throws -> AuthDataResult{
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    func authSignOut() throws{
        try  Auth.auth().signOut()
    }
    func authLogIn(email : String, password : String) async throws -> AuthDataResult{
        try await Auth.auth().signIn(withEmail: email, password: password)
   }
}
