//
//  TitleView.swift
//  TestTutorMe
//
//  Created by Chris Holmes on 1/28/21.
//

import SwiftUI
import UIKit
import GameKit

struct TitleView: View {
    @Binding var titleShowing: Bool
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack {
            VStack{
                Image("icons8-katana-50")
                    .resizable()
                    .colorInvert()
                    .frame(width: 100, height: 100, alignment: .trailing)
                    .position(x: 500, y:150)
                
                Image("icons8-katana-50")
                    .resizable()
                    .colorInvert()
                    .frame(width: 100, height: 100, alignment: .trailing)
                    .position(x: 500, y: -335)
                    .rotationEffect(.degrees(180), anchor: .center)
                    .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
            }
            VStack {
                if titleShowing {
                    
                    VStack(spacing: 8){
                        Spacer()
                        
                        Text("Super Slash")
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundColor(.white)
                            .transition(.move(edge: .trailing))
                            .padding(.bottom, 10)
                        
                        Text("START")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 180, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .transition(.move(edge: .leading))
                            .padding()
                            .border(Color.white, width: 3)
                            .cornerRadius(8)
                            .onTapGesture {
                                withAnimation{
                                    titleShowing.toggle()
                                    viewRouter.currentPage = .LevelsView
                                }
                            }
                        
                        Text("SCORES")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 180, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .transition(.move(edge: .leading))
                            .padding()
                            .border(Color.white, width: 3)
                            .cornerRadius(8)
                            .onTapGesture {
                                withAnimation{
                                    titleShowing.toggle()
                                    viewRouter.currentPage = .highScoresView
                                }
                            }
                        
                        Text("SETTINGS")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 180, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .transition(.move(edge: .leading))
                            .padding()
                            .border(Color.white, width: 3)
                            .cornerRadius(8)
                            .onTapGesture {
                                withAnimation{
                                    titleShowing.toggle()
                                    viewRouter.currentPage = .optionsView
                                }
                            }
                        
                        Text("Connect to GameCentral")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .transition(.move(edge: .leading))
                            .padding()
                            .onTapGesture {
                                withAnimation{
                                    titleShowing.toggle()
                                    viewRouter.currentPage = .gameCenterView
                                }
                            }
                        
                        Spacer()
                        Spacer()
                    }
                }
            }
            .onAppear {
                withAnimation{
                    titleShowing.toggle()
                }
            }
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            TitleView(titleShowing: Binding.constant(true)).environmentObject(ViewRouter())
        }
    }
}

