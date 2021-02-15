//
//  GameView.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/9/21.
//

import SpriteKit
import SwiftUI

struct GameView: View {
    var body: some View {
        SKViewContainer()
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

        return view
    }

    func updateUIView(_ uiView: SKView, context: Context) {}

}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
