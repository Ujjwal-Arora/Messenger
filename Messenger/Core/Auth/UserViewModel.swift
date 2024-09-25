//
//  UserViewModel.swift
//  Messenger
//
//  Created by Ujjwal Arora on 22/09/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SwiftUI
import PhotosUI

@MainActor
class UserViewModel : ObservableObject{
    @Published var currentAuthUser = Auth.auth().currentUser
    @Published var currentFetchedUser : UserModel?
    @Published var email = "@gmail.com"
    @Published var password = "qqqqqq"
    @Published var fullname = "Ujjwal Arora"
    @Published var profilePhotoUrl = ""
    @Published var selectedItem : PhotosPickerItem?
    @Published var showSignUpView = false
    @Published var error : String?

    
    @Published var messageText = ""
    @Published var allMessages = [MessageModel]()
    @Published var recentMessage : MessageModel?
    
    
    private let userService = UserService()
    
    init() {
        Task{
            try? await fetchUserFromFirestore()
        }
    }
    
    func SignUp() async throws{
        do{
            let result = try await userService.authSignUp(email: email, password: password)
            self.currentAuthUser = result.user
            print("SignUp done")
            self.error = nil

            try await uploadImageToFirebaseStorage()
            self.currentFetchedUser = UserModel(email: email, fullname: fullname, profilePhotoUrl: profilePhotoUrl)
            try await uploadUserToFirestore()
        }catch{
            self.error = error.localizedDescription
        }
    }
    func SignOut() throws{
        do{
            try  userService.authSignOut()
            self.currentAuthUser = nil
            self.currentFetchedUser = nil
            print("SignOut done")
        }catch{
            self.error = error.localizedDescription
        }
    }
    func LogIn() async throws{
        do{
            let result = try await userService.authLogIn(email: email, password: password)
            self.currentAuthUser = result.user
            print("LogIn done")
            self.error = nil
            try await fetchUserFromFirestore()
        }catch{
            self.error = error.localizedDescription
        }
    }
    func uploadUserToFirestore() async throws{
        do{
            let encodedNewUser = try Firestore.Encoder().encode(currentFetchedUser)
            let reference = Firestore.firestore().collection("users").document(currentAuthUser?.uid ?? UUID().uuidString)
            try await reference.setData(encodedNewUser)
            print("uploaded user to firestore")
            
        }catch{
            print(error.localizedDescription)
        }
    }
    func fetchUserFromFirestore() async throws{
        do{
            guard let fromId = currentAuthUser?.uid else{return}
            let reference = Firestore.firestore().collection("users").document(fromId)
            self.currentFetchedUser = try await reference.getDocument(as: UserModel.self)
            print("fetched user from firestore")
        }catch{
            print(error.localizedDescription)
        }
    }
    func uploadImageToFirebaseStorage() async throws{
        do{
            if let imageData = try await selectedItem?.loadTransferable(type: Data.self){
                let reference = Storage.storage().reference(withPath: "profilePhoto/\(currentAuthUser?.uid ?? UUID().uuidString)")
                let _ = try await reference.putDataAsync(imageData)
                
                let imageUrl = try await reference.downloadURL()
                self.profilePhotoUrl = imageUrl.absoluteString
                print("profile photo url fetched")
            }
        }catch{
            print(error.localizedDescription)
        }
    }
}
