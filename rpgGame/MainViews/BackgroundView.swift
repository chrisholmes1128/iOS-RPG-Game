//
//  BackgroundView.swift
//  TestTutorMe
//
//  Created by Chris Holmes on 1/28/21.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.7611268939, green: 0.1001818114, blue: 0.06913457299, alpha: 1))]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
