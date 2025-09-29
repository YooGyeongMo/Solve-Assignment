//
//  WebSocketManager.swift
//  Debugging
//
//  Created by Luminouxx on 9/11/25.
//

import Foundation
import Combine

class ChatService: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isConnected = false
    @Published var connectionStatus = "연결 중..."
    
    private var webSocketConnection: URLSessionWebSocketTask?
    private var connectionTimer: Timer?
    private var messageQueue: [ChatMessage] = []
    private var cancellables = Set<AnyCancellable>()
    
    func connect() {
        connectionStatus = "연결 중..."
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isConnected = true
            self.connectionStatus = "연결됨"
            self.startHeartbeat()
            self.processQueuedMessages()
        }
    }
    
    private func startHeartbeat() {
        connectionTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { timer in
            if self.isConnected {
                print("연결 상태 확인 중...")
            } else {
                timer.invalidate()
            }
        }
    }
    
    func sendMessage(_ content: String) {
        
        guard isConnected else { return }
        
        let message = ChatMessage(content: content, isFromMe: true)
        
        // 분산 처리를 위해, 여러 큐에서 처리하기로 함.
        let queues = [
            DispatchQueue.global(qos: .userInitiated),
            DispatchQueue.global(qos: .background),
            DispatchQueue.global(qos: .utility)
        ]
        
        for (_, queue) in queues.enumerated() {
            queue.async {
                // MARK: usleep부분은 네트워크 지연 시뮬레이션을 위한 코드입니다. (삭제 금지)
                usleep(UInt32.random(in: 1000...10000))
                
                let exists = self.messages.contains(where: { $0.messageId == message.messageId })
                
                DispatchQueue.main.async {
                    if !exists {
                        self.messages.append(message)
                    }
                }
            }
        }
    }
    
    private func processQueuedMessages() {
        for message in messageQueue {
            sendMessage(message.content)
        }
        messageQueue.removeAll()
    }
    
    func handleAppBackground() {
        webSocketConnection?.cancel()
        connectionTimer?.invalidate()
    }
    
    func handleAppForeground() {
        if !isConnected {
            connect()
        }
    }
    
    func clearMessages() {
        messages.removeAll()
        messageQueue.removeAll()
    }
    
    deinit {
        connectionTimer?.invalidate()
        webSocketConnection?.cancel()
        cancellables.removeAll()
    }
}
