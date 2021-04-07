//
//  Tutorial4.swift
//  rpgGame
//
//  Created by Chris Holmes on 4/7/21.
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
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .padding()
                    .cornerRadius(8)
                
                Text("To Dash swipe your finger across the screen")
                    .font(.system(size: 25, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 1000, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .cornerRadius(8)
                
                
                Spacer()
                
                
                slideAnimation()
                fingerGestureAnimation()
                    
                
                Spacer()
                
                Text("Tip: Sprinting or attacking too much will deplete your stamina quicker")
                    .font(.system(size: 25, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 1000, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .cornerRadius(8)
                    .padding(.bottom, 30)
                
                HStack {
                    Text("BACK")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
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
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 30, alignment: .center)
                        .transition(.move(edge: .leading))
                        .padding()
                        .border(Color.white, width: 3)
                        .cornerRadius(8)
                        .onTapGesture {
                            viewRouter.currentPage = .Tutorial4View
                        }
                }
            }
        }
    }
}

var slideImages : [UIImage]! = [ UIImage(named: "Warrior_Run_1")!, UIImage(named: "Warrior_Run_2")!, UIImage(named: "Warrior_Run_3")!, UIImage(named: "Warrior_Run_4")!, UIImage(named: "Warrior_Run_5")!, UIImage(named: "Warrior_Run_6")!, UIImage(named: "Warrior_Run_7")!, UIImage(named: "Warrior_Run_8")!, UIImage(named: "Warrior-Slide_1")!, UIImage(named: "Warrior-Slide_2")!, UIImage(named: "Warrior-Slide_3")!, UIImage(named: "Warrior-Slide_4")!, UIImage(named: "Warrior-Slide_5")!, UIImage(named: "Warrior_Run_1")!, UIImage(named: "Warrior_Run_2")!, UIImage(named: "Warrior_Run_3")!, UIImage(named: "Warrior_Run_4")!, UIImage(named: "Warrior_Run_5")!, UIImage(named: "Warrior_Run_6")!, UIImage(named: "Warrior_Run_7")!, UIImage(named: "Warrior_Run_8")!]

let animatedSlideImage = UIImage.animatedImage(with: slideImages, duration: 2.5)

struct slideAnimation: UIViewRepresentable {

    func makeUIView(context: Self.Context) -> UIView {
        let someView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 700))
        let someImage = UIImageView(frame: CGRect(x: 550, y: 100, width: 240, height: 240))
        someImage.clipsToBounds = true
        someImage.layer.cornerRadius = 20
        someImage.autoresizesSubviews = true
        someImage.contentMode = UIView.ContentMode.scaleAspectFill
        someImage.image = animatedSlideImage
        someView.addSubview(someImage)
        return someView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<slideAnimation>) {}
}

var fingerGestureImages : [UIImage]! = [ UIImage(named: "frame_00")!, UIImage(named: "frame_01")!, UIImage(named: "frame_03")!, UIImage(named: "frame_03")!, UIImage(named: "frame_04")!, UIImage(named: "frame_05")!, UIImage(named: "frame_06")!, UIImage(named: "frame_07")!, UIImage(named: "frame_08")!, UIImage(named: "frame_09")!, UIImage(named: "frame_10")!, UIImage(named: "frame_11")!, UIImage(named: "frame_12")!, UIImage(named: "frame_13")!, UIImage(named: "frame_14")!, UIImage(named: "frame_15")!, UIImage(named: "frame_16")!, UIImage(named: "frame_17")!, UIImage(named: "frame_18")!, UIImage(named: "frame_19")!, UIImage(named: "frame_20")!, UIImage(named: "frame_21")!, UIImage(named: "frame_22")!, UIImage(named: "frame_23")!, UIImage(named: "frame_24")!, UIImage(named: "frame_25")!, UIImage(named: "frame_26")!, UIImage(named: "frame_27")!, UIImage(named: "frame_28")!]

let animatedFingerGestureImage = UIImage.animatedImage(with: fingerGestureImages, duration: 1.5)

struct fingerGestureAnimation: UIViewRepresentable {

    func makeUIView(context: Self.Context) -> UIView {
        let someView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 700))
        let someImage = UIImageView(frame: CGRect(x: 550, y: 100, width: 240, height: 240))
        someImage.clipsToBounds = true
        someImage.layer.cornerRadius = 20
        someImage.autoresizesSubviews = true
        someImage.contentMode = UIView.ContentMode.scaleAspectFill
        someImage.image = animatedFingerGestureImage
        someView.addSubview(someImage)
        return someView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<fingerGestureAnimation>) {}
}





struct Tutorial3View_Previews: PreviewProvider {
    static var previews: some View {
        Tutorial3View()
    }
}


