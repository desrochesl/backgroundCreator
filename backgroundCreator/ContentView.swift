//
//  ContentView.swift
//  backgroundCreator
//
//  Created by Luna DesRoches on 11/24/25.
//

import SwiftUI

#if os(macOS)
    import AppKit
    typealias PlatformColor = NSColor
#else
    import UIKit
    typealias PlatformColor = UIColor
#endif

var colors = [
    Color.red,
    Color.blue,
    Color.teal,
    Color.mint,
    Color.yellow,
    Color.indigo,
    Color.orange,
    Color.green,
    Color.black,
]

var possiblePoints: [UnitPoint] = [
    .top, .bottom, .leading, .trailing,
    .topLeading, .topTrailing, .bottomLeading, .bottomTrailing,
]

struct ContentView: View {
    @State var color1 = colors.randomElement()
    @State var color2 = colors.randomElement()

    @State var currentStartPoint: UnitPoint = .bottomLeading
    @State var currentEndPoint: UnitPoint = .topTrailing

    @State private var pastedText: String =
        "Paste from Clipboard to display text!"

    var body: some View {

        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [color1!, color2!],
                    startPoint: currentStartPoint,
                    endPoint: currentEndPoint
                )
                VStack(alignment: .center, spacing: 16) {
                    Text(pastedText)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 12,
                                style: .continuous
                            )
                        )

                }
                .padding()
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        changeColors()
                    } label: {
                        Label("Colors", systemImage: "paintbrush.fill")
                    }

                    Button {
                        pasteContent()
                    } label: {
                        Label("Paste", systemImage: "document.on.clipboard")
                    }

                    Button {
                        // Export logic here
                    } label: {
                        Label("Save", systemImage: "square.and.arrow.down")
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
    private func changeColors() {
        color1 = colors.randomElement()
        color2 = colors.randomElement()

        let newStart = possiblePoints.randomElement() ?? .top
        var newEnd = possiblePoints.randomElement() ?? .bottom

        while newEnd == newStart {
            newEnd = possiblePoints.randomElement() ?? .bottom
        }

        withAnimation {
            currentStartPoint = newStart
            currentEndPoint = newEnd
        }

    }

    private func pasteContent() {
        #if os(macOS)
            let pasteboard = NSPasteboard.general
            if let clipboardString = pasteboard.string(forType: .string) {
                withAnimation {
                    pastedText = clipboardString
                }
            } else {
                withAnimation {
                    pastedText = "Clipboard is empty or does not contain text!"
                }
            }
        #else
            if let clipboardString = UIPasteboard.general.string {
                withAnimation {
                    pastedText = clipboardString
                }
            } else {

                withAnimation {
                    pastedText = "Clipboard is empty or does not contain text!"
                }
            }

        #endif
    }
}

#Preview {
    ContentView()
}
