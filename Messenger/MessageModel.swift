//
//  MessageModel.swift
//  Messenger
//
//  Created by Ujjwal Arora on 22/09/24.
//

import Foundation
import FirebaseFirestore

struct MessageModel : Identifiable,Codable,Hashable{
    var id = UUID().uuidString
    let text : String
    var timestamp = Timestamp()
    let fromId : String
    let toId : String
}
