//
//  SignUpView.swift
//  Messenger
//
//  Created by Ujjwal Arora on 22/09/24.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var vm : UserViewModel
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
//        VStack{
//            Text(vm.recentMessage?.text ?? "no recent message")
//            Text("Auth User : \(vm.currentAuthUser?.email ?? "no auth user")")
//            Text("Fetched User : \(vm.currentFetchedUser?.email ?? "no fetched user")")
//            
//            if let url = URL(string: vm.currentFetchedUser?.profilePhotoUrl ?? ""){
//                AsyncImage(url: url, scale: 10)
//            }
//            TextField("email", text: $vm.email)
//                .textInputAutocapitalization(.never)
//            SecureField("password", text: $vm.password)
//                .textInputAutocapitalization(.never)
//            
//            
//            Button("signUp") {
//                Task{
//                    do{
//                        try await vm.authSignUp()
//                        dismiss()
//                    }catch{
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//        }
//        .navigationTitle("SignUp view")
        
        VStack(spacing : 15){
            Spacer()
            Text("SignUp")
                .font(.largeTitle)
                .fontWeight(.semibold)

            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
            
       //     PhotosPicker("Profile Photo", selection: $vm.selectedUserItem)
            
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
//                    if vm.currentAuthUser != nil{
//                        vm.showLogInView = false
//                        vm.showSignUpView = false
//                    }
                    
                }
            }, label: {
                Text("SignIn")
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
