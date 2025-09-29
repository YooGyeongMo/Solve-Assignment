//
//  MessageProcessor.swift
//  Debugging
//
//  Created by Luminouxx on 9/11/25.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let timestamp: Date
    let isFromMe: Bool
    let messageId: String
    var status: MessageStatus
    
    init(content: String, isFromMe: Bool) {
        self.content = content
        self.timestamp = Date()
        self.isFromMe = isFromMe
        self.messageId = UUID().uuidString
        self.status = isFromMe ? .sending : .sent
    }
}

enum MessageStatus {
    case sending
    case sent
    case failed
}
