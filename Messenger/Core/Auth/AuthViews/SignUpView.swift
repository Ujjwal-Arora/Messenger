//
//  SignUpView.swift
//  Messenger
//
//  Created by Ujjwal Arora on 22/09/24.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    @EnvironmentObject var userVM : UserViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing : 15){
            Spacer()
            Text("SignUp")
                .font(.largeTitle)
                .fontWeight(.semibold)

            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
            
            PhotosPicker("Profile Photo", selection: $userVM.selectedItem)
            
            TextField("Enter fullname", text: $userVM.fullname)
                .modifier(BoxViewModifier(backgroundColor: .gray.opacity(0.1)))
            TextField("Enter email", text: $userVM.email)
                .modifier(BoxViewModifier(backgroundColor: .gray.opacity(0.1)))
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            SecureField("Enter your password", text: $userVM.password)
                .modifier(BoxViewModifier(backgroundColor: .gray.opacity(0.1)))
                .textInputAutocapitalization(.never)
            Button(action: {
                Task{
                    try await userVM.SignUp()
                }
            }, label: {
                Text("SignIn")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .modifier(BoxViewModifier(backgroundColor: .blue))
            })
            if let error = userVM.error{
                Text(error)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .font(.callout)
        .padding()
    }
}

#Preview {
    NavigationStack {
        SignUpView()
            .environmentObject(UserViewModel())
    }

}
