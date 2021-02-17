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
            VStack {
                Image("icons8-katana-50").resizable()
                    .frame(width: 100.0, height: 100.0, alignment: .top)
                    .position(x:80, y: 270)
                    .rotationEffect(.init(degrees: 45))
                    .accentColor(.white)
                    .colorInvert()
                
            }.padding()
            Image("icons8-sword-50").resizable()
                .frame(width: 200.0, height: 140.0, alignment: .top)
                .position(x:300, y: 700)
                .rotationEffect(.init(degrees: 25))
                .colorInvert()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
