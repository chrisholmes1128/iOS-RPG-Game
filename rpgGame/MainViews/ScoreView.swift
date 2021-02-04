//
//  ScoreView.swift
//  TestTutorMe
//
//  Created by Chris Holmes on 2/3/21.
//

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack{
                
                Text("High Scores")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                
                Button(action: {
                    withAnimation {
                        viewRouter.currentPage = .page1
                    }
                }) {
                    Text("Home Screen")
                }.padding()
            }
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView().environmentObject(ViewRouter())
    }
}
