//
//  ContentView.swift
//  backgroundCreator
//
//  Created by Luna DesRoches on 11/24/25.
//

import SwiftUI

var colors = [
    Color.red,
    Color.blue,
    Color.teal,
    Color.mint,
    Color.yellow,
    Color.indigo,
    Color.orange,
    Color.green,
    Color.black]


struct ContentView: View {
    @State var color1 = colors.randomElement()
    @State var color2 = colors.randomElement()
    var body: some View {
        ZStack {
            LinearGradient(colors: [color1!, color2!], startPoint: .bottomLeading, endPoint: .topTrailing).ignoresSafeArea()
            Button("Change Color") {
                color1 = colors.randomElement()
                color2 = colors.randomElement()
            }
            .foregroundStyle(.white)
            .padding(10.0)
            .background(in: RoundedRectangle(cornerRadius: 5.0))

        }
        
    }
}

#Preview {
    ContentView()
}
