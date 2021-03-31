//
//  HowToPlayView.swift
//  rpgGame
//
//  Created by Mitchell Lam on 3/31/21.
//

import SwiftUI

struct HowToPlay: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack{
                
                Text("How To Play")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(.white)
                    .transition(.move(edge: .trailing))
                    .padding(.bottom, 10)
                Button(action: {
                    withAnimation {
                        viewRouter.currentPage = .homeScreenView
                    }
                }){
                    Text("Home Screen")
                }.padding()
            }
        }
    }
}

struct HowToPlay_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlay().environmentObject(ViewRouter())
    }
}
