//
//  InboxView.swift
//  Messenger
//
//  Created by Ujjwal Arora on 23/09/24.
//

import SwiftUI

struct InboxView: View {
    @EnvironmentObject var vm : UserViewModel
    @StateObject private var mm : InboxViewModel
    
    init(vm: UserViewModel) {
        _mm = StateObject(wrappedValue: InboxViewModel(vm: vm))
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(0..<mm.recentUsers.count,id: \.self){num in
                    NavigationLink {
                        ChatView(chatPartner: mm.recentUsers[num])
                            .environmentObject(vm)
                    } label: {
                        HStack(alignment: .top,spacing: 10){
                            if let url = URL(string: mm.recentUsers[num].profilePhotoUrl){
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50,height: 50)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 50,height: 50)
                                }
                            }
                            else{
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 50,height: 50)
                            }
                            VStack(alignment : .leading,spacing: 10) {
                                HStack {
                                    Text(mm.recentUsers[num].email)
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                    Text("\(mm.recentMessages[num].timestamp.dateValue(),style: .offset) ago")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                
                                Text(mm.recentMessages[num].text)
                                    .foregroundStyle(.gray)
                                    .font(.subheadline)
                                    .lineLimit(1)
                            }
                            
                        }
                        
                    }
                    
                    
                    
                }
            }
            Button(action: {
                mm.showNewChatView = true
            }, label: {
                Text("New message")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .modifier(BoxModifier(backgroundColor: .blue))
                    .padding()
            })
            .fullScreenCover(isPresented: $mm.showNewChatView, content: {
                NewChatView()
            })
            
            .task {
                
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    HStack{
                        if let url = URL(string: vm.currentFetchedUser?.profilePhotoUrl ?? ""){
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30,height: 100)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 30,height: 100)
                            }
                            Text("Chats")
                                .font(.title)
                                .fontWeight(.semibold)
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        try? vm.authSignOut()
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
