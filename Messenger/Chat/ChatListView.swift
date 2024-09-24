////
////  ChatListView.swift
////  Messenger
////
////  Created by Ujjwal Arora on 23/09/24.
////
//
//import SwiftUI
//
//struct ChatListView: View {
//    @EnvironmentObject var vm: UserViewModel
//    @StateObject var mm = ChatListViewModel()
//
//    var body: some View {
//        ScrollView(showsIndicators: false) {
//            
//            Text(mm.allUsersExceptSelf.count.formatted())
//            Text(mm.allUsersExceptSelf.count.formatted())
//            ForEach(0..<mm.allUsersExceptSelf.count,id: \.self){index1 in
//                HStack{
//                    Text(mm.allUsersExceptSelf[index1].email)
//               //                   Text(index1.formatted())
//               //     Text(mm.recentMessage?.text ?? "no new msg")
//               //     Text(mm.recentMessage[index1]?.text ?? "no new msg")
//                    Text(mm.recentMessage.count.formatted())
//                }
//                    .task{
//                            print(index1)
//
////                            try? await mm.fetchRecentMessages(currentId: vm.currentAuthUser?.uid ?? "", fromId: mm.allUsersExceptSelf[index1].id ?? "")
//                    }
//            }
//            ForEach(0..<mm.recentMessage.count,id: \.self){ num in
//                Text(mm.recentMessage[num]?.text ?? "nononono")
//            }
//            Divider()
////            ForEach(0..<mm.allUsersExceptSelf.count,id: \.self){index1 in
////   //            Text(mm.allUsersExceptSelf[index].email)
////                Text(index1.formatted())
////                Text(mm.recentMessage?.text ?? "no new msg")
////                    .onChange(of: index1) { oldValue, newValue in
////                        Task{
////                            print(newValue)
////
////                            try await mm.fetchRecentMessages(currentId: vm.currentAuthUser?.uid ?? "", fromId: mm.allUsersExceptSelf[index1].id ?? "")
////                        }
////                    }
////            }
//            Button("SignOut") {
//                do {
//                    try vm.authSignOut()
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//            
////            ForEach(mm.allUsersExceptSelf) { user in
////                NavigationLink {
////                    ChatView(chatPartner: user)
////                        .environmentObject(vm)
////                } label: {
////                    HStack {
////                        VStack {
////                            Text(user.email)
////                            // Fetch the recent message for the user from the dictionary
////                            Text(mm.recentMessages[user.id ?? ""]?.text ?? "no new message")
////                        }
////                    }
////                }
////                .task {
////                    if let userId = user.id {
////                        print("Fetching recent messages for user: \(userId)")
////                        do {
////                            try await mm.fetchRecentMessages(currentId: vm.currentAuthUser?.uid ?? "", fromId: userId)
////                            print(mm.recentMessages[userId]?.text ?? "no text")
////                        } catch {
////                            print("Error fetching recent messages: \(error.localizedDescription)")
////                        }
////                    }
////                }
////            }
//            
//            
//            Text(vm.currentAuthUser?.email ?? "no auth user")
//            Text(vm.currentFetchedUser?.email ?? "no fetched user")
//                .navigationTitle("chatList")
//        }
//        .task {
//            try? await mm.RecentMsg(currentLoggedInUserId: vm.currentAuthUser?.uid ?? "", reciewerId: "")
////            try? await mm.fetchAllUsersExceptSelf(fromId: vm.currentAuthUser?.uid ?? "")
//        }
//    }
//}
//
//#Preview {
//    NavigationStack {
//        ChatListView()
//            .environmentObject(UserViewModel())
//    }
//}
import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var vm: UserViewModel
    @StateObject var mm = ChatListViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                // Display count of users
                Text("Total Users: \(mm.allUsersExceptSelf.count.formatted())")
                
                // List of users excluding self
                ForEach(mm.allUsersExceptSelf, id: \.id) { user in
                    HStack {
                        Text(user.email)
                        Spacer()
                        // Fetch recent messages when displaying the user
                        if let recentMessage = mm.recentMessage.first(where: { $0?.fromId == user.id }) {
                            Text(recentMessage?.text ?? "No new message")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        } else {
                            Text("No new message")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .task {
                        // Fetch recent messages for each user
                        do {
                            try await mm.fetchRecentMessages(currentLoggedInUserId: vm.currentAuthUser?.uid ?? "", receiverId: user.id ?? "")
                        } catch {
                            print("Error fetching recent messages: \(error.localizedDescription)")
                        }
                    }
                }
                
                Divider()
                
                // Sign out button
                Button("Sign Out") {
                    do {
                        try vm.authSignOut()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                // Display current authenticated user
                Text("Authenticated User: \(vm.currentAuthUser?.email ?? "No Auth User")")
                Text("Fetched User: \(vm.currentFetchedUser?.email ?? "No Fetched User")")
            }
            .navigationTitle("Chat List")
        }
        .task {
            // Fetch users excluding the current user on initial load
            do {
                try await mm.fetchAllUsersExceptSelf(currentUserId: vm.currentAuthUser?.uid ?? "")
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatListView()
            .environmentObject(UserViewModel())
    }
}
