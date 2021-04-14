//
//  GameView.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/9/21.
//

import SpriteKit
import SwiftUI

struct GameView: View {
    @State private var pauseMenuShowing = false
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var started: Bool
    var level: Int
    
    var body: some View {
        let scene = GameScene.level(self.level)
        
        ZStack {
            
            PauseMenuView(pauseMenuShowing: $pauseMenuShowing).padding()
            
            SKViewContainer(level: self.level, scene: scene!).ignoresSafeArea()
            
            HStack(spacing: 40) {
                //pause button
                Button(action: {
                    scene?.pause()
                }) {
                    Image("pauseButton")
                        .resizable()
                        .colorInvert()
                        .frame(width: 40, height: 40, alignment: .trailing)
                        .padding(.leading, 200)
                        .padding(.bottom, 220)
                }
                
                Button(action: {
                    scene?.currentGameState = .gameOver
                    scene?.gameOver()
                    viewRouter.currentPage = .PauseMenuView
                }) {
                    Image("menuIcon")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .trailing)
                        .padding(.trailing, 10)
                        .padding(.bottom, 220)
                }
            }.padding(.bottom, 1620 / 2 - 100)
            .padding(.leading, 2160 / 2 - 160)
        }
    }
}

struct SKViewContainer: UIViewRepresentable {
    var level:Int
    var scene:GameScene
    func makeUIView(context: Context) -> SKView {
        
        let view = SKView()
        
        view.presentScene(scene)
        view.ignoresSiblingOrder = false
        view.showsFPS = false
        view.showsNodeCount = false
        view.showsPhysics = false
        
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {}
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(started: Binding.constant(true), level: 1).environmentObject(ViewRouter())
    }
}
