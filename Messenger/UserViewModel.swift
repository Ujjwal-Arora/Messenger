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
    
    @Published var messageText = ""
    @Published var allMessages = [MessageModel]()
    @Published var recentMessage : MessageModel?
    
    private let userService = UserService()
    
    func authSignIn() async throws{
        do{
            let result = try await userService.authSignIn(email: email, password: password)
            self.currentAuthUser = result.user
            print("authSignIn done")
            
            try await uploadImageToFirebaseStorage()
            self.currentFetchedUser = UserModel(email: email, password: password, fullname: fullname, profilePhotoUrl: profilePhotoUrl)
            try await uploadUserToFirestore()
        }catch{
            print(error.localizedDescription)
        }
    }
    func authSignOut() throws{
        do{
            try  userService.authSignOut()
            self.currentAuthUser = nil
            self.currentFetchedUser = nil
            print("authSignOut done")
        }catch{
            print(error.localizedDescription)
        }
    }
    func authLogIn() async throws{
        do{
            let result = try await userService.authLogIn(email: email, password: password)
            self.currentAuthUser = result.user
            print("authLogIn done")
            try await fetchUserFromFirestore()
        }catch{
            print(error.localizedDescription)
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
            let reference = Firestore.firestore().collection("users").document(currentAuthUser?.uid ?? UUID().uuidString)
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
    func uploadMessageToFirestore(chatPartnerId : String) async throws{
        do{
            guard let fromId = currentAuthUser?.uid else{return}
            let newMessage = MessageModel(text: messageText, fromId: fromId, toId: chatPartnerId)
            let encodedMessage = try Firestore.Encoder().encode(newMessage)
            let reference = Firestore.firestore().collection("messages")
            try await reference.document(fromId).collection(chatPartnerId).document(newMessage.id).setData(encodedMessage)
            try await reference.document(chatPartnerId).collection(fromId).document(newMessage.id).setData(encodedMessage)
            print("uploaded msg to firestore")
        }catch{
            print(error.localizedDescription)
        }
    }
    func fetchMessagesFromFirestore(chatPartnerId : String){
        guard let fromId = currentAuthUser?.uid else{return}
        
        let query = Firestore.firestore()
            .collection("messages")
            .document(fromId)
            .collection(chatPartnerId)
            .order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, _ in
            
            guard let allMessagesDocuments = snapshot?.documents else {return}
            do{
                self.recentMessage = try allMessagesDocuments.last?.data(as: MessageModel.self)
                self.allMessages = try allMessagesDocuments.compactMap { doc in
                    try doc.data(as: MessageModel.self)
                }
            }catch{
                print(error.localizedDescription)
            }
            print("fetched msgs from firestore")
        }
    }
}
