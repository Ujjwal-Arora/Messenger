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
        VStack{
            Text(vm.recentMessage?.text ?? "no recent message")
            Text("Auth User : \(vm.currentAuthUser?.email ?? "no auth user")")
            Text("Fetched User : \(vm.currentFetchedUser?.email ?? "no fetched user")")
            
            if let url = URL(string: vm.currentFetchedUser?.profilePhotoUrl ?? ""){
                AsyncImage(url: url, scale: 10)
            }
            TextField("email", text: $vm.email)
                .textInputAutocapitalization(.never)
            SecureField("password", text: $vm.password)
                .textInputAutocapitalization(.never)
            
            
            Button("LogIn") {
                Task{
                    do{
                        try await vm.authLogIn()
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .navigationTitle("logIn view")

    }
}

#Preview {
    LogInView()
        .environmentObject(UserViewModel())
}
