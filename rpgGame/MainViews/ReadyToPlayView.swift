//
//  ReadyToPlayView.swift
//  rpgGame
//
//  Created by Chris Holmes on 3/31/21.
//

import SwiftUI

struct ReadyToPlayView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State var started = false
    @State private var timeRemaining = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            BackgroundView()
            
            VStack{
                Spacer()
                
                Text("Ready?")
                    .underline()
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .padding(.bottom, 20)
                    .cornerRadius(8)
                
                VStack {
                    Text("\(timeRemaining)")
                        .font(.system(size: 70, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 30, alignment: .center)
                        .transition(.move(edge: .leading))
                        .padding()
                        .cornerRadius(8)
                }
                .onReceive(timer) { time in
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    }
                    else {
                        started.toggle()
                        viewRouter.currentPage = .GameView
                    }
                }
                
                Spacer()
                
            }
        }
    }
}




struct ReadyToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        ReadyToPlayView()
    }
}


