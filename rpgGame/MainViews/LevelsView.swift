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
                Text("Level 1")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .padding()
                    .border(Color.white, width: 3)
                    .cornerRadius(8)
                    .onTapGesture {
                        viewRouter.currentPage = .GameView
                    }
                
                Text("Level 2")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .padding()
                    .border(Color.white, width: 3)
                    .cornerRadius(8)
                    .onTapGesture {
                    }
                
                Text("Level 3")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .padding()
                    .border(Color.white, width: 3)
                    .cornerRadius(8)
                    .onTapGesture {
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
