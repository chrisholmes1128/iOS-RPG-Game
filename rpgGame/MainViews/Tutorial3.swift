//
//  Tutorial1.swift
//  rpgGame
//
//  Created by Chris Holmes on 3/31/21.
//

import SwiftUI

struct Tutorial3View: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        ZStack{
            BackgroundView()
            
            VStack{
                
                Text("Tutorial: Part 3")
                    .underline()
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .padding()
                    .cornerRadius(8)
                
                Text("Make sure to pay attention to your health and stamina bar..")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 700, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .cornerRadius(8)
                
                Text("This will be visable in the top left corner of the screen")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 700, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .cornerRadius(8)
                
                Spacer()
                
                Group{
                    HStack{
                        Text("   Health ->")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        Image("Health")
                            .resizable()
                            .frame(width: 400, height: 40, alignment: .trailing)
                    }
                    HStack{
                        Text("Stamina ->")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        Image("Stamina")
                            .resizable()
                            .frame(width: 400, height: 40, alignment: .trailing)
                    }
                }
                
                Spacer()
                
                Text("Tip: Sprinting or attacking too much will deplete your stamina quicker")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 700, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .cornerRadius(8)
                    .padding(.bottom, 30)
                
                HStack {
                    Text("BACK")
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 30, alignment: .center)
                        .transition(.move(edge: .leading))
                        .padding()
                        .border(Color.white, width: 3)
                        .cornerRadius(8)
                        .onTapGesture {
                            viewRouter.currentPage = .Tutorial2View
                        }
                    Text("NEXT")
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 30, alignment: .center)
                        .transition(.move(edge: .leading))
                        .padding()
                        .border(Color.white, width: 3)
                        .cornerRadius(8)
                        .onTapGesture {
                            viewRouter.currentPage = .ReadyToPlayView
                        }
                }
            }
        }
    }
}

struct Tutorial3View_Previews: PreviewProvider {
    static var previews: some View {
        Tutorial3View()
    }
}

