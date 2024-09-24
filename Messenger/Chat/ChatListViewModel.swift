////
////  ChatListViewModel.swift
////  Messenger
////
////  Created by Ujjwal Arora on 23/09/24.
////
//
//import Foundation
//import FirebaseFirestore
//
//@MainActor
//class ChatListViewModel : ObservableObject{
//    @Published var recentMessage = [MessageModel?]()
//    
//    @Published var allUsersExceptSelf = [UserModel]()
//    @Published var allRecieverids = [String]()
//
//    
//    @Published var chatInfo = [UserModel : MessageModel?]()
//
//    func fetchAllUsersExceptSelf(currentUserId : String) async throws{
//        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
//        
////        self.allUsersExceptSelf = try snapshot.documents.compactMap { document in
////            guard document.documentID != fromId else {return nil}
////            return try document.data(as: UserModel.self)
////        }
//        for doc in snapshot.documents{
//            if doc.documentID != currentUserId {
//                let user = try doc.data(as: UserModel.self)
//            }
//        }
//    }
////    func fetchRecentMessages(user : UserModel,currentId : String, fromId : String) async throws{
////        let query = Firestore.firestore()
////            .collection("messages")
////            .document(currentId)
////            .collection(fromId)
////            .order(by: "timestamp", descending: true)
////            .limit(to: 1)
////        
////        let msg : MessageModel?
////        if let recentMessageDocument = try await query.getDocuments().documents.first{
////             msg = try recentMessageDocument.data(as: MessageModel.self)
////            
////        //    self.recentMessage.append(msg)
////        }else{
////            msg = nil
////       //     self.recentMessage.append(nil)
////        }
////        self.chatInfo.append(user : msg)
////  //      print(recentMessage?.text ?? "no new msg")
////    }
//    func RecentMsg(currentLoggedInUserId : String, reciewerId : String) async throws{
//        print("🌞❤️")
////        print( try await Firestore.firestore().collection("messages").document(currentLoggedInUserId).getDocument().documentID)
////        
////        try await Firestore.firestore().collection("messages").document(currentLoggedInUserId).collection(reciewerId).order(by: "timestamp").limit(to: 1).getDocuments()
////        
////        func receiversForCurrentLoggedInUser(currentLoggedInUserId: String) async throws {
//            // Fetch the document for the current user
//            let snapshot = try await Firestore.firestore().collection("messages").document(currentLoggedInUserId).getDocument()
//            
//            // Check if the document exists
//
//            // Get the collection of receiver IDs directly from the document
//            // Assuming your document structure has the receiver IDs stored as an array or similar
//            let receiverIds = snapshot.data()?["receiverIds"] as? [String] ?? []
//            print(receiverIds)
//            // Optionally, remove duplicates if needed
//   //         self.allUsersExceptSelf = Array(Set(receiverIds))
//    //    }
//        print("🌞❤️")
//    }
////    func recieversForCurrentLoggedInUser(currentLoggedInUserId : String) async throws{
////        let snapshot = try await Firestore.firestore().collection("messages").document(currentLoggedInUserId).documentID
////        self.allUsersExceptSelf = try snapshot.documents.compactMap { doc in
////            return try doc.data(as: UserModel.self)
////        }
////    }
//    func receiversForCurrentLoggedInUser(currentLoggedInUserId: String) async throws {
//        // Fetch the document for the current user
//        let snapshot = try await Firestore.firestore().collection("messages").document(currentLoggedInUserId).getDocument()
//        
//        let receiverIds = snapshot.data()?["receiverIds"] as? [String] ?? []
//        
//        // Optionally, remove duplicates if needed
//        self.allRecieverids = Array(Set(receiverIds))
//    }
//}

import Foundation
import FirebaseFirestore

@MainActor
class ChatListViewModel: ObservableObject {
    @Published var recentMessage = [MessageModel?]()
    @Published var allUsersExceptSelf = [UserModel]()
    @Published var allReceiverIds = [String]()
    @Published var chatInfo = [UserModel: MessageModel?]()

    func fetchAllUsersExceptSelf(currentUserId: String) async throws {
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        
        self.allUsersExceptSelf = try snapshot.documents.compactMap { document in
            guard document.documentID != currentUserId else { return nil }
            return try document.data(as: UserModel.self)
        }
    }

    func fetchRecentMessages(currentLoggedInUserId: String, receiverId: String) async throws {
        let query = Firestore.firestore()
            .collection("messages")
            .document(currentLoggedInUserId)
            .collection(receiverId)
            .order(by: "timestamp", descending: true)
            .limit(to: 1)

        let recentMessageDocument = try await query.getDocuments().documents.first
        let msg = try recentMessageDocument?.data(as: MessageModel.self)
        
        if let msg = msg {
            self.recentMessage.append(msg)
            // Here, you could also map the msg to chatInfo if needed
            if let user = allUsersExceptSelf.first(where: { $0.id == receiverId }) {
                chatInfo[user] = msg
            }
        }
    }

    func receiversForCurrentLoggedInUser(currentLoggedInUserId: String) async throws {
        let snapshot = try await Firestore.firestore().collection("messages").document(currentLoggedInUserId).getDocument()

        // Assuming your document structure contains receiver IDs
        let receiverIds = snapshot.data()?["receiverIds"] as? [String] ?? []
        self.allReceiverIds = Array(Set(receiverIds))
        print("❤️\(allReceiverIds)")
    }
}
