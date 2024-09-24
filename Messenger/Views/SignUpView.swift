//
//  SignUpView.swift
//  Messenger
//
//  Created by Ujjwal Arora on 22/09/24.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    @EnvironmentObject var vm : UserViewModel
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
            
            PhotosPicker("Profile Photo", selection: $vm.selectedItem)
            
            TextField("Enter fullname", text: $vm.fullname)
                .modifier(BoxModifier(backgroundColor: .gray.opacity(0.1)))
            TextField("Enter email", text: $vm.email)
                .modifier(BoxModifier(backgroundColor: .gray.opacity(0.1)))
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            SecureField("Enter your password", text: $vm.password)
                .modifier(BoxModifier(backgroundColor: .gray.opacity(0.1)))
                .textInputAutocapitalization(.never)
            Button(action: {
                Task{
                    try await vm.authSignUp()
                }
            }, label: {
                Text("SignIn")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .modifier(BoxModifier(backgroundColor: .blue))
            })
            
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
