//
//  LevelsView.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/9/21.
//

import SwiftUI

struct LevelsView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        ZStack{
            BackgroundView()
            
            VStack{
                Text("Tutorial")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .padding()
                    .border(Color.white, width: 3)
                    .cornerRadius(8)
                    .onTapGesture {
                        viewRouter.currentPage = .Tutorial1View
                        viewRouter.level = 0
                    }
                
                Text("LEVEL 1")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .padding()
                    .border(Color.white, width: 3)
                    .cornerRadius(8)
                    .onTapGesture {
                        viewRouter.currentPage = .GameView
                        viewRouter.level = 1
                    }
                
                Text("LEVEL 2")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .padding()
                    .border(Color.white, width: 3)
                    .cornerRadius(8)
                    .onTapGesture {
                        viewRouter.currentPage = .GameView
                        viewRouter.level = 2
                    }
                Text("BACK")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .padding()
                    .border(Color.white, width: 3)
                    .cornerRadius(8)
                    .onTapGesture {
                        viewRouter.currentPage = .homeScreenView
                    }
            }
        }
    }
}

struct LevelsView_Previews: PreviewProvider {
    static var previews: some View {
        LevelsView()
    }
}
