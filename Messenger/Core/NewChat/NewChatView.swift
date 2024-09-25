//
//  NewChatView.swift
//  Messenger
//
//  Created by Ujjwal Arora on 24/09/24.
//

import SwiftUI

struct NewChatView: View {
    @StateObject var newChatVM = NewChatViewModel()
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
                    
                    ForEach(newChatVM.allUsersExceptSelf){ user in
                        NavigationLink {
                            ChatView(chatPartner: user)
                                .onDisappear {
                                    dismiss()
                                }
                        } label: {
                            HStack{
                                ProfilePhotoView(profilePhotoUrl: user.profilePhotoUrl, size: 30)
                                Text(user.email)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }.foregroundStyle(.black)
                        }
                        Divider()
                    }.frame(maxWidth: .infinity,alignment: .leading)
                }.padding()
            }
            .searchable(text: $newChatVM.searchText)
            .task {
                try? await newChatVM.fetchAllUsersExceptSelf(currentUserId: userVM.currentAuthUser?.uid ?? "")
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
