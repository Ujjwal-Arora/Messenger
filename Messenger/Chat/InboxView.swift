import SwiftUI
import FirebaseFirestore

struct InboxView: View {
    @State var recentUsers: [UserModel] = []
    @State var recentMessages: [MessageModel] = []
    private var db = Firestore.firestore()
    @EnvironmentObject var vm : UserViewModel
    
    var body: some View {
        List {
            ForEach(0..<recentUsers.count,id: \.self){num in
                NavigationLink {
                    ChatView(chatPartner: recentUsers[num])
                        .environmentObject(vm)
                } label: {
                    VStack(alignment: .leading) {
                        Text("Receiver: \(recentUsers[num].email)")
                        Text("Last Message: \(recentMessages[num].text)")
                    }
                }

               
            }
        }
        .onAppear {
            listenForRecentMessages(for: "6Vz7DNa7gudPkRHyTC3Q0uIj7Q63")
        }
    }

    func listenForRecentMessages(for senderId: String) {
        db.collection("messages")
            .document(senderId)
            .collection("recentMessages")
            .addSnapshotListener { snapshot, _ in
               
                guard let snapshot = snapshot else {
                print("No recent messages found")
                    return
                }
                self.recentUsers = []
                self.recentMessages = []

                for document in snapshot.documents {
                    let receiverId = document.documentID
                    do {
                        let messageData = try document.data(as: MessageModel.self)

                        Task {
                            do {
                                let userModel = try await fetchUsersFromId(chatPartnerId: receiverId)
                                
                                DispatchQueue.main.async {
                                    self.recentUsers.append(userModel)
                                    self.recentMessages.append(messageData)
                                }
                            } catch {
                                print("Error fetching user: \(error.localizedDescription)")
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
    }

    func fetchUsersFromId(chatPartnerId: String) async throws -> UserModel {
        try await db.collection("users").document(chatPartnerId).getDocument().data(as: UserModel.self)
    }
}

#Preview {
    NavigationStack {
        InboxView()
            .environmentObject(UserViewModel())

    }
}
