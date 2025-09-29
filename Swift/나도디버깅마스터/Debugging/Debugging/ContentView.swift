//
//  ContentView.swift
//  Debugging
//
//  Created by Luminouxx on 9/11/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var animateRipple = false

    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 12) {
                    Text("나도 이제 디버깅 마스터?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.primary, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("메모리 누수와 Race Condition을\n실전으로 체험해보세요!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(.top, 50)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.purple.opacity(0.3), lineWidth: 2)
                        .scaleEffect(animateRipple ? 1.5 : 1.0)
                        .opacity(animateRipple ? 0 : 0.6)
                        .frame(width: 200)
                        .animation(.easeOut(duration: 2).repeatForever(autoreverses: false), value: animateRipple)
                    
                    Circle()
                        .stroke(Color.purple.opacity(0.3), lineWidth: 2)
                        .scaleEffect(animateRipple ? 1.5 : 1.0)
                        .opacity(animateRipple ? 0 : 0.6)
                        .frame(width: 270)
                        .animation(.easeOut(duration: 2).repeatForever(autoreverses: false), value: animateRipple)
                    
                    Circle()
                        .stroke(Color.purple.opacity(0.3), lineWidth: 2)
                        .scaleEffect(animateRipple ? 1.5 : 1.0)
                        .opacity(animateRipple ? 0 : 0.6)
                        .frame(width: 340)
                        .animation(.easeOut(duration: 2).repeatForever(autoreverses: false), value: animateRipple)
                    
                    Image("SwiftUIKeyRing")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                }
                .onAppear {
                    animateRipple = true
                }
                
                Spacer()
                
                NavigationLink(destination: ChatView()) {
                    HStack {
                        Image(systemName: "bubble.left.and.bubble.right")
                        Text("채팅 시작하기")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ContentView()
}
