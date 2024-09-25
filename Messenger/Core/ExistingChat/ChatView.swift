//
//  ChatView.swift
//  Messenger
//
//  Created by Ujjwal Arora on 23/09/24.
//

import SwiftUI

struct ChatView: View {
    @StateObject var chatVM = ChatViewModel()
    @EnvironmentObject var userVM : UserViewModel
    let chatPartner : UserModel?
    
    var body: some View {
        
        if let currentUid = userVM.currentAuthUser?.uid, let toId = chatPartner?.id{
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        ProfilePhotoView(profilePhotoUrl: chatPartner?.profilePhotoUrl ?? "", size: 100)
                        ForEach(chatVM.allMessages) { msg in
                            Text(msg.text)
                                .foregroundStyle(msg.fromId == currentUid ? .white : .black)
                                .modifier(BoxViewModifier(backgroundColor: msg.fromId == currentUid ? .blue : .gray.opacity(0.3)))
                                .frame(maxWidth: .infinity,alignment: msg.fromId == currentUid ? .trailing : .leading)
                                .padding(.horizontal)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .onChange(of: chatVM.allMessages) { _, newMessages in
                        if let lastMessageId = newMessages.last?.id {
                            withAnimation {
                                proxy.scrollTo(lastMessageId, anchor: .bottom)
                            }
                        }
                    }
                }
                HStack{
                    TextField("message", text: $chatVM.messageText,axis: .vertical)
                        .modifier(BoxViewModifier(backgroundColor: .gray.opacity(0.1)))
                    
                    
                    Button(action: {
                        Task{
                            try await chatVM.uploadMessageToFirestore(fromId: currentUid, chatPartnerId: toId)
                            chatVM.messageText = ""
                        }
                    }, label: {
                        Text("Send")
                            .fontWeight(.semibold)
                    })
                }
                .navigationTitle(chatPartner?.fullname ?? "no name")
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea()
                .padding(.horizontal)
            }
            .task {
                chatVM.fetchMessagesFromFirestore(fromId: currentUid, chatPartnerId: toId)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatView(chatPartner: MockData.user)
            .environmentObject(UserViewModel())
    }
}
