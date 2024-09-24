//
//  LogInView.swift
//  Messenger
//
//  Created by Ujjwal Arora on 22/09/24.
//

import SwiftUI

struct LogInView: View {
    @EnvironmentObject var vm : UserViewModel

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
                TextField("Enter email", text: $vm.email)
                    .modifier(BoxModifier(backgroundColor: .gray.opacity(0.1)))
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)

                SecureField("Enter your password", text: $vm.password)
                    .modifier(BoxModifier(backgroundColor: .gray.opacity(0.1)))
                    .textInputAutocapitalization(.never)
                Button(action: {
                    Task{
                        try await vm.authLogIn()
                    }
                }, label: {
                    Text("LogIn")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .modifier(BoxModifier(backgroundColor: .blue))
                })
                Spacer()
                Button {
                    vm.showSignUpView = true
                    
                } label: {
                    Text("Dont have an account? SignUp")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.blue)
                        .padding()
                }
                .sheet(isPresented: $vm.showSignUpView, content: {
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
