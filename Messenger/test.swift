//import SwiftUI
//
//struct MyView: View {
//    @State private var rr = 0
//
//    var body: some View {
//        ScrollView(showsIndicators: false) {
//            
//            ForEach(0..<100, id: \.self) { index1 in
//                Text(index1.formatted())
//                    .task {
//                        // Here you can add logic to perform something when each view appears
//                        print("View appeared for index: \(index1)")
//                    }
//            }
//            Divider()
//            ForEach(0..<100,id: \.self){index1 in
//   //            Text(mm.allUsersExceptSelf[index].email)
//                Text(index1.formatted())
//   //             Text(mm.recentMessage?.text ?? "no new msg")
//                    .onChange(of: index1) { oldValue, newValue in
//                        print(newValue)
//                        print(index1)
//
////                        Task{
////                            print(newValue)
////                            print(index1)
////
//////                            try await mm.fetchRecentMessages(currentId: vm.currentAuthUser?.uid ?? "", fromId: mm.allUsersExceptSelf[index1].id ?? "")
////                        }
//                    }
//            }
//            ForEach(0..<10, id: \.self) { num in
//                Text(rr.formatted())
//          //      Text(num.formatted())
//                    .onChange(of: num) { oldValue, newValue in
//                        rr = 111
//                    }
//            }
//            
//        }
//    }
//}
//#Preview {
//    MyView()
//}
