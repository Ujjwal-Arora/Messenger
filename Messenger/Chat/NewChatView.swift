//
//  NewChatView.swift
//  Messenger
//
//  Created by Ujjwal Arora on 24/09/24.
//

import SwiftUI

struct NewChatView: View {
    @StateObject var vm = NewChatViewModel()
    @EnvironmentObject var userVM : UserViewModel
    
    var body: some View {
        VStack{
        ScrollView{
            ForEach(vm.allUsersExceptSelf){ user in
                //   Text(user.email)
                HStack{
                    if let url = URL(string: user.profilePhotoUrl){
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 25,height: 25)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        
                        
                        
                    }else{
                        Image(systemName: "person.circle")
                    }
                    Text(user.email)
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }.frame(maxWidth: .infinity,alignment: .leading)
            }.task {
                try? await vm.fetchAllUsersExceptSelf(currentUserId: userVM.currentAuthUser?.uid ?? "")
            }
        }
        //        for ChatListView
        //        VStack{
        //            ScrollView{
        //
        //            }
        //            Button(action: {
        //               // showNewChatView = true
        //            }, label: {
        //                Text("New message")
        //                    .foregroundStyle(.white)
        //                    .frame(maxWidth: .infinity)
        //                    .modifier(BoxModifier(backgroundColor: .blue))
        //                    .padding()
        //            })
        //        }
    }
}

#Preview {
    NewChatView()
        .environmentObject(UserViewModel())
}
