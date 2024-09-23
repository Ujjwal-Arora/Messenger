//
//  ChatListView.swift
//  Messenger
//
//  Created by Ujjwal Arora on 23/09/24.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var vm : UserViewModel
    @StateObject var mm = ChatViewModel()

    var body: some View {
        ScrollView(showsIndicators : false){
            Button("SignOut") {
                do{
                    try vm.authSignOut()
                }catch{
                    print(error.localizedDescription)
                }
            }
            ForEach(mm.allUsersExceptSelf){ user in
                NavigationLink {
                    ChatView(chatPartner: user) //should i pass on the whole user or just user.id
                        .environmentObject(vm) // why do we have to give it here but i didnt give it in logINView/SignUpView
                } label: {
                    HStack {
                  //      AsyncImage(url: URL(string: user.profilePhotoUrl), scale: 10)
                        VStack {
                            Text(user.email)
                            Text(mm.recentMessage?.text ?? " no new message")
                        }
                    }
                    
                }
            }
            Text(vm.currentAuthUser?.email ?? "no auth user")
            Text(vm.currentFetchedUser?.email ?? "no fetched user")
            .navigationTitle("chatList")
        }
        .task {
            try? await mm.fetchAllUsersExceptSelf(fromId: vm.currentAuthUser?.uid ?? "")
//            try? await mm.fetchMessagesFromFirestore(fromId: vm.currentAuthUser?.uid ?? "", chatPartnerId: <#T##String#>)
        }
    }
}

#Preview {
    NavigationStack {
        ChatListView()
            .environmentObject(UserViewModel())
    }
}
