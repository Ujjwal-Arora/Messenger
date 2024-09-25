//
//  InboxView.swift
//  Messenger
//
//  Created by Ujjwal Arora on 23/09/24.
//

import SwiftUI

struct InboxView: View {
    @EnvironmentObject var userVM : UserViewModel
    @StateObject private var inboxVM : InboxViewModel
    
    init(vm: UserViewModel) {
        _inboxVM = StateObject(wrappedValue: InboxViewModel(vm: vm))
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(0..<inboxVM.recentUsers.count,id: \.self){num in
                    NavigationLink(value: inboxVM.recentUsers[num]) {
                        HStack(alignment: .top,spacing: 10){
                            ProfilePhotoView(profilePhotoUrl: inboxVM.recentUsers[num].profilePhotoUrl, size: 50)
                            VStack(alignment : .leading,spacing: 10) {
                                HStack {
                                    Text(inboxVM.recentUsers[num].email)
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                    Text(inboxVM.recentMessages[num].timestamp.dateValue(),style: .time)
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                Text(inboxVM.recentMessages[num].text)
                                    .foregroundStyle(.gray)
                                    .font(.subheadline)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
            }.navigationDestination(for: UserModel.self) { user in
                ChatView(chatPartner: user)
                    .environmentObject(userVM)
            }

            Button(action: {
                inboxVM.showNewChatView = true
            }, label: {
                Text("New message")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .modifier(BoxViewModifier(backgroundColor: .blue))
                    .padding()
            })
            .fullScreenCover(isPresented: $inboxVM.showNewChatView, content: {
                NewChatView()
            })
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    HStack{
                        ProfilePhotoView(profilePhotoUrl: userVM.currentFetchedUser?.profilePhotoUrl ?? "", size: 30)
                        Text("Chats")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        try? userVM.SignOut()
                    }, label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.gray)
                    })
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        InboxView(vm: UserViewModel())
            .environmentObject(UserViewModel())
    }
}
