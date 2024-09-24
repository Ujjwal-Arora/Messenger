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
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack{
                ScrollView{
                    Text("App Users")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                    ForEach(vm.allUsersExceptSelf){ user in
                        NavigationLink {
                            ChatView(chatPartner: user)
                                .onDisappear {
                                    dismiss()
                                }
                        } label: {
                            HStack{
                                if let url = URL(string: user.profilePhotoUrl){
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 30,height: 30)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 30,height: 30)
                                    }
                                }else{
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .frame(width: 30,height: 30)

                                }
                                Text(user.email)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }.foregroundStyle(.black)
                        }
                        Divider()
                    }.frame(maxWidth: .infinity,alignment: .leading)
                }.padding()
            }
            .searchable(text: $vm.searchText)
            .task {
                try? await vm.fetchAllUsersExceptSelf(currentUserId: userVM.currentAuthUser?.uid ?? "")
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }        
    }
}

#Preview {
    NewChatView()
        .environmentObject(UserViewModel())
}
