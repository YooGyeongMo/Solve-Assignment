//
//  ChatView.swift
//  Debugging
//
//  Created by Luminouxx on 9/11/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var chatService = ChatService()
    @State private var messageText = ""
    @State private var buttonCount = 0
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        VStack {
            // 연결 상태
            HStack {
                Circle()
                    .fill(chatService.isConnected ? .green : .red)
                    .frame(width: 8, height: 8)
                Text(chatService.connectionStatus)
                    .font(.caption)
                Spacer()
                
                Text("버튼 누른 횟수: \(buttonCount)개")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("메시지: \(chatService.messages.count)개")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            
            // 메시지 리스트
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(chatService.messages) { message in
                            MessageBubbleView(message: message)
                        }
                    }
                }
                .onChange(of: chatService.messages.count) { _, newCount in
                    if let lastMessage = chatService.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            HStack {
                Button("빠른 전송 테스트 (5개)") {
                    buttonCount += 1
                    for i in 1...5 {
                        chatService.sendMessage("메시지 \(i)")
                    }
                }
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
                
                Button("초기화") {
                    buttonCount = 0
                    chatService.clearMessages()
                }
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.red.opacity(0.2))
                .cornerRadius(8)
                
                Spacer()
            }
            .padding(.horizontal)
            
            // 메시지 입력
            HStack {
                TextField("메시지를 입력하세요", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("전송") {
                    if !messageText.isEmpty {
                        chatService.sendMessage(messageText)
                        messageText = ""
                    }
                }
                .disabled(messageText.isEmpty)
            }
            .padding()
        }
        .navigationTitle("채팅")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("닫기") {
                    dismiss()
                }
            }
        }
        .onAppear {
            chatService.connect()
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                chatService.handleAppBackground()
            case .active:
                chatService.handleAppForeground()
            default:
                break
            }
        }
    }
}

struct MessageBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromMe {
                Spacer()
            }
            
            VStack(alignment: message.isFromMe ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding()
                    .background(message.isFromMe ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundColor(message.isFromMe ? .white : .primary)
                    .cornerRadius(12)
                
                HStack(spacing: 4) {
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    if message.isFromMe {
                        switch message.status {
                        case .sending:
                            Image(systemName: "clock")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        case .sent:
                            Image(systemName: "checkmark")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        case .failed:
                            Image(systemName: "exclamationmark.triangle")
                                .font(.caption2)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
            if !message.isFromMe {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ChatView()
}
