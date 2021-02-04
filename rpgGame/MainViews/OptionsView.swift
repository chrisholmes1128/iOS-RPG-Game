//
//  OptionsView.swift
//  TestTutorMe
//
//  Created by Chris Holmes on 2/3/21.
//
import SwiftUI

struct OptionsView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
       
        ZStack {
            BackgroundView()
            VStack{
                
                Text("Settings")
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

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView().environmentObject(ViewRouter())
    }
}


