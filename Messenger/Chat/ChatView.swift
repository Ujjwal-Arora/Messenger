//
//  ChatView.swift
//  Messenger
//
//  Created by Ujjwal Arora on 23/09/24.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var vm = ChatViewModel()
    @EnvironmentObject var mm : UserViewModel
    let chatPartner : UserModel?

    var body: some View {
        
        ScrollView {
            if let toId = chatPartner?.id{
                Text(toId)
                VStack {
                    Text(vm.recentMessage?.text ?? "no recent message")
                    Text("Auth User : \(mm.currentAuthUser?.email ?? "no auth user")")
                    Text("Fetched User : \(mm.currentFetchedUser?.email ?? "no fetched user")")
                    
                   
                    HStack{
                        TextField("message", text: $vm.messageText,axis: .vertical)
                        Button("send") {
                            Task{
                                guard let fromId = mm.currentAuthUser?.uid else{return}
                                try await vm.uploadMessageToFirestore(fromId: fromId, chatPartnerId: toId)
                            }
                        }
                    }
                    ForEach(vm.allMessages) { msg in
                        Text(msg.text)
                            .padding()
                            .background(msg.toId == toId ? .blue : .green)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                }
                .toolbar{
                    HStack{
                        if let url = URL(string: chatPartner?.profilePhotoUrl ?? ""){
                            AsyncImage(url: url, scale: 70)
                            Text(chatPartner?.fullname ?? "no name")
                        }
                        
                    }
                    
                    
                }
                .padding()
                
                .onChange(of: mm.currentAuthUser, { _, _ in
                    
                    guard let fromId = mm.currentAuthUser?.uid else{return}
                    vm.fetchMessagesFromFirestore(fromId: fromId, chatPartnerId: toId)
                    
                    //     fetchRecentMessageFromFirestore(chatPartnerId: "zpxyuqXPU3RDJbEdMwtAhhGPwvv1")
                    
                })
                .task {
                    //              try? await vm.fetchUserFromFirestore()
                    
                    guard let fromId = mm.currentAuthUser?.uid else{return}
             //       guard let toId = chatPartner.id else{return}
                    
                    vm.fetchMessagesFromFirestore(fromId: fromId, chatPartnerId: toId)
                    
                    //    fetchRecentMessageFromFirestore(chatPartnerId: "zpxyuqXPU3RDJbEdMwtAhhGPwvv1")
                }
                
            }}
       // .navigationTitle("chat view")
        .padding()
    }
}

#Preview {
    NavigationStack {
        ChatView(chatPartner: MockData.user)
            .environmentObject(UserViewModel())
    }
}
