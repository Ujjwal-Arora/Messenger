//
//  ChatView.swift
//  Messenger
//
//  Created by Ujjwal Arora on 23/09/24.
//

import SwiftUI

struct ChatView: View {
    @StateObject var vm = ChatViewModel()
    @EnvironmentObject var mm : UserViewModel
    let chatPartner : UserModel?
    
    var body: some View {
        
        if let toId = chatPartner?.id{
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack{
                            if let url = URL(string: chatPartner?.profilePhotoUrl ?? ""){
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100,height: 100)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 100,height: 100)
                                }
                                Text(chatPartner?.email ?? "")
                                    .font(.title)
                                    .fontWeight(.semibold)
                            }
                        }
                        ForEach(vm.allMessages) { msg in
                            HStack{
                                Text(msg.text)
                                    .foregroundStyle(msg.toId == toId ? .white : .black)
                                    .modifier(BoxModifier(backgroundColor: msg.toId == toId ? .blue : .gray.opacity(0.3)))
                                    .frame(maxWidth: .infinity,alignment: msg.toId == toId ? .trailing : .leading)
                                    .padding(.horizontal)
                            }
                        }
                    }.frame(maxWidth: .infinity)
                        .onChange(of: vm.allMessages) { _, newMessages in
                            if let lastMessageId = newMessages.last?.id {
                                withAnimation {
                                    proxy.scrollTo(lastMessageId, anchor: .bottom)
                                }
                            }
                        }
                }
                HStack{
                    TextField("message", text: $vm.messageText,axis: .vertical)
                        .modifier(BoxModifier(backgroundColor: .gray.opacity(0.1)))
                    
                    
                    Button(action: {
                        Task{
                            guard let fromId = mm.currentAuthUser?.uid else{return}
                            try await vm.uploadMessageToFirestore(fromId: fromId, chatPartnerId: toId)
                            vm.messageText = ""
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
                
            }.onChange(of: mm.currentAuthUser, { _, _ in
                
                guard let fromId = mm.currentAuthUser?.uid else{return}
                vm.fetchMessagesFromFirestore(fromId: fromId, chatPartnerId: toId)
                
            })
            .task {
                guard let fromId = mm.currentAuthUser?.uid else{return}
                
                vm.fetchMessagesFromFirestore(fromId: fromId, chatPartnerId: toId)
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
