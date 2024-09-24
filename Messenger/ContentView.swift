////
////  ContentView.swift
////  Messenger
////
////  Created by Ujjwal Arora on 21/09/24.
////
//
//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//import PhotosUI
//import FirebaseStorage
//
//struct ContentView: View {
//    @EnvironmentObject var vm : UserViewModel
//    
////    @State var currentAuthUser = Auth.auth().currentUser
////    @State var currentFetchedUser : UserModel?
////    @State var email = "@gmail.com"
////    @State var password = "qqqqqq"
////    @State var fullname = "Ujjwal Arora"
////    @State var profilePhotoUrl = ""
////    @State var selectedItem : PhotosPickerItem?
////    
////    @State var messageText = ""
////    @State var allMessages = [MessageModel]()
////    @State var recentMessage : MessageModel?
//
//    
//    
//    
//    
//    
//    
//    var body: some View {
//        ScrollView {
//            VStack {
//                Text(vm.recentMessage?.text ?? "no recent message")
//                Text("Auth User : \(vm.currentAuthUser?.email ?? "no auth user")")
//                Text("Fetched User : \(vm.currentFetchedUser?.email ?? "no fetched user")")
//                
//                if let url = URL(string: vm.currentFetchedUser?.profilePhotoUrl ?? ""){
//                                AsyncImage(url: url, scale: 10)
//                            }
//                PhotosPicker("select pic", selection: $vm.selectedItem)
//                TextField("email", text: $vm.email)
//                    .textInputAutocapitalization(.never)
//                SecureField("password", text: $vm.password)
//                    .textInputAutocapitalization(.never)
//                
//                Button("SignUp") {
//                    Task{
//                        do{
//                            try await vm.authSignUp()
//                        }catch{
//                            print(error.localizedDescription)
//                        }
//                    }
//                }
//                Button("SignOut") {
//                    do{
//                        try vm.authSignOut()
//                    }catch{
//                        print(error.localizedDescription)
//                    }
//                }
//                Button("LogIn") {
//                    Task{
//                        do{
//                            try await vm.authLogIn()
//                        }catch{
//                            print(error.localizedDescription)
//                        }
//                    }
//                }
//                TextField("message", text: $vm.messageText)
//                Button("send") {
//                    Task{
////                        try await vm.uploadMessageToFirestore(chatPartnerId: "zpxyuqXPU3RDJbEdMwtAhhGPwvv1")
//                    }
//                }
//                ForEach(vm.allMessages) {
//                    Text($0.text)
//                }
//                
//            }
//            .padding()
//
//            .onChange(of: vm.currentAuthUser, { _, _ in
// //               vm.fetchMessagesFromFirestore(chatPartnerId: "zpxyuqXPU3RDJbEdMwtAhhGPwvv1")
//           //     fetchRecentMessageFromFirestore(chatPartnerId: "zpxyuqXPU3RDJbEdMwtAhhGPwvv1")
//
//            })
////            .task {
////                try? await vm.fetchUserFromFirestore()
//// //               vm.fetchMessagesFromFirestore(chatPartnerId: "zpxyuqXPU3RDJbEdMwtAhhGPwvv1")
////            //    fetchRecentMessageFromFirestore(chatPartnerId: "zpxyuqXPU3RDJbEdMwtAhhGPwvv1")
////            }
//        
//        }
//        .navigationTitle("content view")
//        .padding()
//    }
////    func authSignIn() async throws{
////        let result = try await Auth.auth().createUser(withEmail: email, password: password)
////        self.currentAuthUser = result.user
////        print("authSignIn done")
////        
////        try await uploadImageToFirebaseStorage()
////        self.currentFetchedUser = UserModel(email: email, password: password, fullname: fullname, profilePhotoUrl: profilePhotoUrl)
////        try await uploadUserToFirestore()
////    }
////    func authSignOut() throws{
////        try  Auth.auth().signOut()
////        self.currentAuthUser = nil
////        self.currentFetchedUser = nil
////        print("authSignOut done")
////    }
////    func authLogIn() async throws{
////        let result = try await Auth.auth().signIn(withEmail: email, password: password)
////        self.currentAuthUser = result.user
////        print("authLogIn done")
////        try await fetchUserFromFirestore()
////    }
////    func uploadUserToFirestore() async throws{
////        do{
////            let encodedNewUser = try Firestore.Encoder().encode(currentFetchedUser)
////            let reference = Firestore.firestore().collection("users").document(currentAuthUser?.uid ?? UUID().uuidString)
////            try await reference.setData(encodedNewUser)
////            print("uploaded user to firestore")
////            
////        }catch{
////            print(error.localizedDescription)
////        }
////    }
////    func fetchUserFromFirestore() async throws{
////        do{
////            let reference = Firestore.firestore().collection("users").document(currentAuthUser?.uid ?? UUID().uuidString)
////            self.currentFetchedUser = try await reference.getDocument(as: UserModel.self)
////            print("fetched user from firestore")
////        }catch{
////            print(error.localizedDescription)
////        }
////    }
////    func uploadImageToFirebaseStorage() async throws{
////        do{
////            if let imageData = try await selectedItem?.loadTransferable(type: Data.self){
////                let reference = Storage.storage().reference(withPath: "profilePhoto/\(currentAuthUser?.uid ?? UUID().uuidString)")
////                let _ = try await reference.putDataAsync(imageData)
////                
////                let imageUrl = try await reference.downloadURL()
////                self.profilePhotoUrl = imageUrl.absoluteString
////                print("profile photo url fetched")
////            }
////        }catch{
////            print(error.localizedDescription)
////        }
////    }
////    func uploadMessageToFirestore(chatPartnerId : String) async throws{
////        do{
////            guard let fromId = currentAuthUser?.uid else{return}
////            let newMessage = MessageModel(text: messageText, fromId: fromId, toId: chatPartnerId)
////            let encodedMessage = try Firestore.Encoder().encode(newMessage)
////            let reference = Firestore.firestore().collection("messages")
////            try await reference.document(fromId).collection(chatPartnerId).document(newMessage.id).setData(encodedMessage)
////            try await reference.document(chatPartnerId).collection(fromId).document(newMessage.id).setData(encodedMessage)
////            print("uploaded msg to firestore")
////        }catch{
////            print(error.localizedDescription)
////        }
////    }
////    func fetchMessagesFromFirestore(chatPartnerId : String){
////        guard let fromId = currentAuthUser?.uid else{return}
////        
////        let query = Firestore.firestore()
////            .collection("messages")
////            .document(fromId)
////            .collection(chatPartnerId)
////            .order(by: "timestamp")
////        
////        query.addSnapshotListener { snapshot, _ in
////            
////            guard let allMessagesDocuments = snapshot?.documents else {return}
////            do{
////                self.recentMessage = try allMessagesDocuments.last?.data(as: MessageModel.self)
////                self.allMessages = try allMessagesDocuments.compactMap { doc in
////                    try doc.data(as: MessageModel.self)
////                }
////            }catch{
////                print(error.localizedDescription)
////            }
////            print("fetched msgs from firestore")
////        }
////    }
////    func fetchRecentMessageFromFirestore(chatPartnerId : String){
////        guard let fromId = currentAuthUser?.uid else {return}
////        
////        let query = Firestore.firestore()
////            .collection("messages")
////            .document(fromId)
////            .collection(chatPartnerId)
////            .order(by: "timestamp", descending: true)
////          //  .limit(to: 1)
////        
////        query.addSnapshotListener { snapshot, _ in
////            
////            guard let messageDocument = snapshot?.documents.first else {return}
////            do{
////                self.recentMessage = try messageDocument.data(as: MessageModel.self)
////            }catch{
////                print(error.localizedDescription)
////            }
////        }
////    }
//}
//
//#Preview {
//    NavigationStack {
//        ContentView()
//            .environmentObject(UserViewModel())
//    }
//}
