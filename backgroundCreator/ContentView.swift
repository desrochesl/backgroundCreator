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

struct ContentView: View {
    @State var color1 = colors.randomElement()
    @State var color2 = colors.randomElement()

    @State private var pastedText: String =
        "Tap the button below to paste text from your clipboard onto this gradient."

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [color1!, color2!],
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            ).edgesIgnoringSafeArea(.all)

            VStack(alignment: .center, spacing: 16) {
                Text(pastedText)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                    )

                HStack {
                    Spacer()
                    Button("Change Colors") {
                        changeColors()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .foregroundStyle(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                    )
                    Spacer()
                    Button("Paste from Clipboard") {
                        pasteContent()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .foregroundStyle(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                    )
                    Spacer()

                }
            }
            .padding()
        }
    }

    private func changeColors() {
        color1 = colors.randomElement()
        color2 = colors.randomElement()
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
                // Fallback if clipboard is empty or contains non-text data
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
