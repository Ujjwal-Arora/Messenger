//
//  ChatViewModel.swift
//  Messenger
//
//  Created by Ujjwal Arora on 23/09/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class ChatViewModel : ObservableObject{
//    @Published var currentAuthUser = Auth.auth().currentUser
//    @Published var currentFetchedUser : UserModel?
    @Published var allUsersExceptSelf = [UserModel]()

    
    @Published var messageText = ""
    @Published var allMessages = [MessageModel]()
    @Published var recentMessage : MessageModel?

    func uploadMessageToFirestore(fromId : String, chatPartnerId : String) async throws{
        do{
//            guard let fromId = currentAuthUser?.uid else{return}
            let newMessage = MessageModel(text: messageText, fromId: fromId, toId: chatPartnerId)
            let encodedMessage = try Firestore.Encoder().encode(newMessage)
            let reference = Firestore.firestore().collection("messages")
            try await reference.document(fromId).collection(chatPartnerId).document(newMessage.id).setData(encodedMessage)
            try await reference.document(chatPartnerId).collection(fromId).document(newMessage.id).setData(encodedMessage)
            print("uploaded msg to firestore")
            
            //upload recent message
            let recentCurrentUserReference = Firestore.firestore().collection("messages").document(fromId).collection("recentMessages").document(chatPartnerId)
            try await recentCurrentUserReference.setData(encodedMessage)
            
            let recentPartnerReference = Firestore.firestore().collection("messages").document(chatPartnerId).collection("recentMessages").document(fromId)
            try await recentPartnerReference.setData(encodedMessage)

            
            
        }catch{
            print(error.localizedDescription)
        }
    }

    func fetchMessagesFromFirestore(fromId : String, chatPartnerId : String){
//        guard let fromId = currentAuthUser?.uid else{return}
        
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
                print("fetched msgs from firestore")
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    func fetchAllUsersExceptSelf(fromId : String) async throws{
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        
        self.allUsersExceptSelf = try snapshot.documents.compactMap { document in
            guard document.documentID != fromId else {return nil}
            return try document.data(as: UserModel.self)
        }
    }
    
    
    
}
