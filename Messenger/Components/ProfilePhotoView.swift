//
//  ProfilePhotoView.swift
//  Messenger
//
//  Created by Ujjwal Arora on 25/09/24.
//

import SwiftUI

struct ProfilePhotoView: View {
    let profilePhotoUrl : String
    let size : CGFloat
    var body: some View {
        VStack{
            if let url = URL(string: profilePhotoUrl){
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
            }else{
                Image(systemName: "person.circle")
                    .resizable()
            }
        }.frame(width: size,height: size)
    }
}

#Preview {
    ProfilePhotoView(profilePhotoUrl: MockData.user.profilePhotoUrl, size: 100)
}
