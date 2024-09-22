//
//  MessengerApp.swift
//  Messenger
//
//  Created by Ujjwal Arora on 21/09/24.
//

import SwiftUI
import Firebase

@main
struct MessengerApp: App {
    @StateObject var vm = UserViewModel()

    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                if vm.currentAuthUser == nil{
                    LogInView()
                        .environmentObject(vm)
                }else{
                    ContentView()
                        .environmentObject(vm)
                }
            }
        }
    }
}
