////
////  SwiftUIView.swift
////  Messenger
////
////  Created by Ujjwal Arora on 24/09/24.
////
//
//import SwiftUI
//import FirebaseFirestore
//
//struct SwiftUIView: View {
//    @State var allUserIds = [String]()
//    @State var allmsgs = [ MessageModel]()
//
//    @EnvironmentObject var mm : UserViewModel
//    
//    var body: some View {
//        Text(recentMessages.count.formatted())
//        
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//        Text(allmsgs.count.formatted())
//        
//        Text(allmsgs.first?.text ?? " ")
//            .task {
//                listenForRecentMessages3(for: "6Vz7DNa7gudPkRHyTC3Q0uIj7Q63")//working
//                listenForAllRecentMessages1(for: "6Vz7DNa7gudPkRHyTC3Q0uIj7Q63")
//                try? await getAllUserIds()
//                do {
//                    try await listenForAllRecentMessages()
//                    //    let collectionNames = try await getSubCollectionNames()
//                    //    print("Sub-collections: \(collectionNames)")
//                } catch {
//                    print("Error fetching collection names: \(error.localizedDescription)")
//                }
//            }
//    }
//    @State var recentMessages: [(String, MessageModel)] = []
//        private var db = Firestore.firestore()
//
//        func listenForRecentMessages3(for senderId: String) {
//            // Fetch all documents in the `recentMessages` subcollection (receiverId documents)
//            db.collection("messages")
//                .document(senderId)
//                .collection("recentMessages")
//                .addSnapshotListener {  snapshot, error in
//                    if let error = error {
//                        print("Error fetching recent messages: \(error.localizedDescription)")
//                        return
//                    }
//
//                    guard let snapshot = snapshot else {
//                        print("No recent messages found")
//                        return
//                    }
//
//                    // Store recent messages
//                    self.recentMessages = snapshot.documents.compactMap { document in
//                                        let receiverId = document.documentID
//                                        do {
//                                            // Attempt to decode the message data
//                                            let messageData = try document.data(as: MessageModel.self)
//                                            return (receiverId, messageData) // Return tuple of receiverId and messageData
//                                        } catch {
//                                            print("Error decoding message data: \(error.localizedDescription)")
//                                            return nil // Return nil if decoding fails
//                                        }
//                                    }
//                }
//        }
//    
//    
//    // import FirebaseFirestore
//    
//    func listenForRecentMessages() {
//        let db = Firestore.firestore()
//        
//        // Set up the listener for recent messages in the subcollection
//        db.collection("messages")
//            .document("6Vz7DNa7gudPkRHyTC3Q0uIj7Q63")
//            .collection("recentMessages")
//            .order(by: "timestamp", descending: true)
//            .addSnapshotListener { snapshot, error in
//                // Check for errors
//                if let error = error {
//                    print("Error fetching recent messages: \(error.localizedDescription)")
//                    return
//                }
//                
//                // Process the snapshot
//                guard let snapshot = snapshot, !snapshot.documents.isEmpty else {
//                    print("No recent messages found")
//                    return
//                }
//                
//                // Get the most recent message
//                if let document = snapshot.documents.first {
//                    let data = document.data()
//                    print("Latest message: \(data)")
//                }
//            }
//    }
//
//    func listenForAllRecentMessages1(for senderId: String) {
//        let db = Firestore.firestore()
//
//        // Step 1: Fetch all documents in the `recentMessages` subcollection (receiverId documents)
//        db.collection("messages")
//            .document(senderId)
//            .collection("recentMessages")
//            .addSnapshotListener { snapshot, error in
//                if let error = error {
//                    print("Error fetching recent messages: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let snapshot = snapshot else {
//                    print("No recent messages found")
//                    return
//                }
//
//                // Step 2: Loop through each receiverId in the `recentMessages` collection
//                for document in snapshot.documents {
//                    let receiverId = document.documentID
//                    let recentMessageData = document.data() // This contains the recent message data
//                    self.allmsgs.append(try! document.data(as: MessageModel.self))
//                    // Step 3: Process the recent message data for each receiver
//                    print("❤️Receiver: \(receiverId), Recent Message: \(recentMessageData)")
//                }
//            }
//       // print(allmsgs)
//    }
//
//    func listenForAllRecentMessages() {
//        let db = Firestore.firestore()
//
//        // Step 1: Fetch all documents in the `recentMessages` subcollection (which has receiverId as document ID)
//        db.collection("messages")
//            .document("6Vz7DNa7gudPkRHyTC3Q0uIj7Q63")
//            .collection("recentMessages")
//            .addSnapshotListener { snapshot, error in
//                if let error = error {
//                    print("Error fetching recent messages: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let snapshot = snapshot else {
//                    print("No recent messages found")
//                    return
//                }
//
//                // Step 2: Loop through each receiverId in the `recentMessages` collection
//                for document in snapshot.documents {
//                    let receiverId = document.documentID
//                    
//                    // Step 3: Fetch the most recent message from the receiver's `messages` subcollection
//                    db.collection("messages")
//                        .document("6Vz7DNa7gudPkRHyTC3Q0uIj7Q63")
//                        .collection("recentMessages")
//                        .document(receiverId)
//                        .collection("messages")
//                        .order(by: "timestamp", descending: true)
//                        .limit(to: 1) // Fetch only the latest message
//                        .getDocuments { messageSnapshot, error in
//                            if let error = error {
//                                print("Error fetching recent message for receiver \(receiverId): \(error.localizedDescription)")
//                                return
//                            }
//
//                            guard let messageSnapshot = messageSnapshot, let messageDocument = messageSnapshot.documents.first else {
//                                print("No recent message found for receiver \(receiverId)")
//                                return
//                            }
//
//                            let messageData = messageDocument.data()
//                            print("Sender: \("6Vz7DNa7gudPkRHyTC3Q0uIj7Q63"), Receiver: \(receiverId), Latest Message: \(messageData)")
//                        }
//                }
//            }
//    }
//    
//    func getAllMessages() async throws {
//        Firestore.firestore().collection("messages").document("zpxyuqXPU3RDJbEdMwtAhhGPwvv1").collection("6Vz7DNa7gudPkRHyTC3Q0uIj7Q63")
//    }
//    
//    func getAllUserIds() async throws{
//        print("❤️")
//        await print(try Firestore.firestore().collection("messages").document("zpxyuqXPU3RDJbEdMwtAhhGPwvv1")
//            .getDocument()
//                    //   .collection("6Vz7DNa7gudPkRHyTC3Q0uIj7Q63").collectionID
//        )
//        print("❤️")
//        
//    }
//    //  import FirebaseFirestore
//    
//    //    func getSubCollectionNames() async throws -> [String] {
//    //        let db = Firestore.firestore()
//    //        let documentRef = db.collection("messages").document("zpxyuqXPU3RDJbEdMwtAhhGPwvv1")
//    //
//    //        // Get the sub-collections
//    //        let collections = try await documentRef.collections()
//    //
//    //        // Extract the collection names
//    //        let collectionNames = collections.map { $0.id }
//    //
//    //        return collectionNames
//    //    }
//    //    func getSubCollectionNames1() async throws -> [String] {
//    //        let db = Firestore.firestore()
//    //        let documentRef = db.collection("messages").document("zpxyuqXPU3RDJbEdMwtAhhGPwvv1")
//    //
//    //        // Get the sub-collections
//    //        let subcollections = try await documentRef.collections().getDocuments()
//    //
//    //        // Extract the collection names
//    //        let collectionNames = subcollections.documents.map { $0.id }
//    //
//    //        return collectionNames
//    //    }
//    //    func getSubCollectionNames2() async throws -> [String] {
//    //        let db = Firestore.firestore()
//    //
//    //        // Get the subcollections
//    //        let subcollections = try await db.collection("messages").document("zpxyuqXPU3RDJbEdMwtAhhGPwvv1").collections()
//    //
//    //        // Extract the collection names
//    //        let collectionNames = subcollections.map { $0.id }
//    //
//    //        return collectionNames
//    //    }
//    //    // Usage example
//    //
//    //
//}
//
//#Preview {
//    NavigationStack {
//        SwiftUIView()
//            .environmentObject(UserViewModel())
//    }
//}
