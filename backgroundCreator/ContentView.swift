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
            
            VStack {
//                Spacer()

                Text("AHHHHHHHHH")
                    .foregroundStyle(.black)
                    .font(.title)
                
                
                Button("Change Color") {
                    color1 = colors.randomElement()
                    color2 = colors.randomElement()
                }
    //            .foregroundStyle(.black)
    //            .font(Font.largeTitle.bold())
                .padding(5.0)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
            }
            
            



        }
        
    }
}

#Preview {
    ContentView()
}
