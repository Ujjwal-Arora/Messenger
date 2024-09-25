//
//  LogInView.swift
//  Messenger
//
//  Created by Ujjwal Arora on 22/09/24.
//

import SwiftUI

struct LogInView: View {
    @EnvironmentObject var userVM : UserViewModel

    var body: some View {

            VStack(spacing : 15){
                Spacer()
                Text("LogIn")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .padding()
                TextField("Enter email", text: $userVM.email)
                    .modifier(BoxViewModifier(backgroundColor: .gray.opacity(0.1)))
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)

                SecureField("Enter your password", text: $userVM.password)
                    .modifier(BoxViewModifier(backgroundColor: .gray.opacity(0.1)))
                    .textInputAutocapitalization(.never)
                Button(action: {
                    Task{
                        try await userVM.authLogIn()
                    }
                }, label: {
                    Text("LogIn")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .modifier(BoxViewModifier(backgroundColor: .blue))
                })
                Spacer()
                Button {
                    userVM.showSignUpView = true
                    
                } label: {
                    Text("Dont have an account? SignUp")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.blue)
                        .padding()
                }
                .sheet(isPresented: $userVM.showSignUpView, content: {
                    SignUpView()
                })

            }
            .font(.callout)
            .padding()
        }
}

#Preview {
    NavigationStack {
        LogInView()
            .environmentObject(UserViewModel())
    }
}
