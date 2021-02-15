//
//  GameCenterView.swift
//  rpgGame
//
//  Created by Chris Holmes on 2/8/21.
//

import SwiftUI

struct GameCenterView: View {
    
    @State private var titleShowing = false
    
    var body: some View {
        ZStack{
            GameCenterManager()
        }
    }
}

struct GamerCenterView_Previews: PreviewProvider {
    static var previews: some View {
        GameCenterView()
    }
}

