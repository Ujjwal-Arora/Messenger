//
//  NewChatViewModel.swift
//  Messenger
//
//  Created by Ujjwal Arora on 24/09/24.
//

import Foundation
import FirebaseFirestore

@MainActor
class NewChatViewModel : ObservableObject {
    @Published var allUsersExceptSelf = [UserModel]()
    
        //mne sirf jisse isne baat kari h vhi loh utha liye kya
    func fetchAllUsersExceptSelf(currentUserId : String) async throws{
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        self.allUsersExceptSelf = try snapshot.documents.compactMap { doc in
            guard doc.documentID != currentUserId else {return nil}
            return try doc.data(as: UserModel.self)
        }
    }
}
