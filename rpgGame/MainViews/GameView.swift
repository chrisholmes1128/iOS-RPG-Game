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
    
    var body: some View {
        ZStack {
            PauseMenuView(pauseMenuShowing: $pauseMenuShowing).padding()
                
            SKViewContainer().ignoresSafeArea()
                
            VStack(alignment: .leading) {
                Button(action: {
                    withAnimation {
                        pauseMenuShowing.toggle()
                        viewRouter.currentPage = .PauseMenuView
                    }
                }) {
                    Image("pauseButton")
                        .resizable()
                        .colorInvert()
                        .frame(width: 40, height: 40, alignment: .trailing)
                }
            }.padding(.bottom, 740)
            .padding(.leading, 980)
        }
    }
}

struct SKViewContainer: UIViewRepresentable {

    func makeUIView(context: Context) -> SKView {

        let view = SKView()

        guard let scene = SKScene(fileNamed: "GameScene")
            else {
                view.backgroundColor = UIColor.red
                return view
        }
        view.presentScene(scene)

        view.ignoresSiblingOrder = false
        view.showsFPS = true
        view.showsNodeCount = true
        //view.showsPhysics = true

        return view
    }

    func updateUIView(_ uiView: SKView, context: Context) {}

}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView().environmentObject(ViewRouter())
    }
}
