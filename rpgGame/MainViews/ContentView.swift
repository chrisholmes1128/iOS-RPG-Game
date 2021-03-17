//
//  ContentView.swift
//  rpgGame
//
//  Created by Chris Holmes on 2/4/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var titleShowing = false
    
    var body: some View {
        ZStack{
            
            GameCenterManager()
            
            VStack{
                BackgroundView()
            }
            TitleView(titleShowing: $titleShowing).padding(.bottom)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
