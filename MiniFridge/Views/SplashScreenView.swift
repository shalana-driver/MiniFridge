//
//  SplashScreenView.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-07-13.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    @State var trigger = true
    @State private var showSignInView: Bool = true
    
    var body: some View {
        
        ZStack {
            Color.theme.background.ignoresSafeArea(.all)
            VStack {
                if isActive {
                    TabBarView(showSignInView: $showSignInView)
                } else {
                    VStack {
                        
                        Image(systemName: "refrigerator")
                            .resizable()
                            .frame(width: 40, height: 60)
                            .foregroundColor(Color.theme.accent)
                        Text("MiniFridge")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color.theme.accent)
                    }
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
                }
                
            }
            .padding()
        }
    }
}

#Preview {
    SplashScreenView()
}
