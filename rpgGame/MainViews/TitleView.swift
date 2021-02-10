//
//  TitleView.swift
//  TestTutorMe
//
//  Created by Chris Holmes on 1/28/21.
//

import SwiftUI

struct TitleView: View {
    @Binding var titleShowing: Bool
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
            VStack {
                if titleShowing {
                    VStack(spacing: 20){
                        Spacer()
                        
                        Text("Pirate Invaders")
                            .font(.system(size: 45, weight: .heavy))
                            .foregroundColor(.white)
                            .transition(.move(edge: .trailing))
                        
                        Spacer()
                        
                        Text("START")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 120, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
                        Text("OPTIONS")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 120, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .transition(.move(edge: .leading))
                            .padding()
                            .border(Color.white, width: 3)
                            .cornerRadius(8)
                            .onTapGesture {
                                withAnimation{
                                    titleShowing.toggle()
                                    viewRouter.currentPage = .page2
                                }
                            }
                        
                        Text("SCORES")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 120, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .transition(.move(edge: .leading))
                            .padding()
                            .border(Color.white, width: 3)
                            .cornerRadius(8)
                            .onTapGesture {
                                withAnimation{
                                    titleShowing.toggle()
                                    viewRouter.currentPage = .page3
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

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            TitleView(titleShowing: Binding.constant(true)).environmentObject(ViewRouter())
        }
    }
}

