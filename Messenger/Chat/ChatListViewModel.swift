//
//  ChatListViewModel.swift
//  Messenger
//
//  Created by Ujjwal Arora on 23/09/24.
//

import Foundation
import FirebaseFirestore

@MainActor
class ChatListViewModel : ObservableObject{
    @Published var allUsersExceptSelf = [UserModel]()

    func fetchAllUsersExceptSelf(fromId : String) async throws{
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        
        self.allUsersExceptSelf = try snapshot.documents.compactMap { document in
            guard document.documentID != fromId else {return nil}
            return try document.data(as: UserModel.self)
        }
    }
    
}
