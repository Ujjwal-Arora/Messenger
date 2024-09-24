//
//  InboxViewModel.swift
//  Messenger
//
//  Created by Ujjwal Arora on 25/09/24.
//

import Foundation
import FirebaseFirestore

@MainActor
class InboxViewModel: ObservableObject {
    @Published var recentUsers: [UserModel] = []
    @Published var recentMessages: [MessageModel] = []
    @Published var showNewChatView = false
    
    private let vm: UserViewModel
    
    init(vm: UserViewModel) {
        self.vm = vm
        Task {
            try? await listenForRecentMessages(fromId: vm.currentAuthUser?.uid ?? "")
        }
    }
    
    func listenForRecentMessages(fromId: String) async throws {
        
        Firestore.firestore().collection("messages")
            .document(fromId)
            .collection("recentMessages")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, _ in
                guard let snapshot = snapshot else {
                    print("No recent msgs")
                    return
                }
                
                Task {
                    var fetchedUsers: [UserModel] = []
                    var fetchedMessages: [MessageModel] = []
                    
                    for document in snapshot.documents {
                        let receiverId = document.documentID
                        do {
                            let messageData = try document.data(as: MessageModel.self)
                            let userModel = try await self.fetchUsersFromId(chatPartnerId: receiverId)
                            
                            //used tempVariables to solve sorting issues
                            fetchedUsers.append(userModel)
                            fetchedMessages.append(messageData)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    self.recentUsers = fetchedUsers
                    self.recentMessages = fetchedMessages
                }
            }
    }
    
    func fetchUsersFromId(chatPartnerId: String) async throws -> UserModel {
        return try await Firestore.firestore().collection("users")
            .document(chatPartnerId)
            .getDocument()
            .data(as: UserModel.self)
    }
}
