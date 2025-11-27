//
//  ContentView.swift
//  backgroundCreator
//
//  Created by Luna DesRoches on 11/24/25.
//

import SwiftUI

#if os(macOS)
    import AppKit
    internal import UniformTypeIdentifiers
    typealias PlatformImage = NSImage
#else
    import UIKit
    typealias PlatformImage = UIImage
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
            backgroundCard
                .ignoresSafeArea()
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
                            saveImage()
                        } label: {
                            Label("Save", systemImage: "square.and.arrow.down")
                        }
                    }
                }
                #if os(macOS)
                    .toolbarBackground(.hidden, for: .windowToolbar)
                #else
                    .toolbarBackground(.hidden, for: .navigationBar)
                #endif
        }
    }

    var backgroundCard: some View {
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
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                    )
                    .font(.system(size: 45, weight: .bold, design: .rounded))
            }
            .padding()
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

    func saveImage() {
        let renderer = ImageRenderer(
            content: backgroundCard.frame(width: 1080, height: 1080)
        )
        renderer.scale = 1.0

        #if os(macOS)
            if let nsImage = renderer.nsImage {
                let panel = NSSavePanel()
                panel.allowedContentTypes = [.png]
                panel.nameFieldStringValue = "MyWallpaper.png"
                panel.begin { response in
                    if response == .OK, let url = panel.url {
                        if let tiff = nsImage.tiffRepresentation,
                            let bitmap = NSBitmapImageRep(data: tiff),
                            let pngData = bitmap.representation(
                                using: .png,
                                properties: [:]
                            )
                        {
                            try? pngData.write(to: url)
                        }
                    }
                }
            }
        #else
            if let uiImage = renderer.uiImage {
                let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: uiImage)
            }

        #endif

    }

}

#if os(iOS)
class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Save error: \(error.localizedDescription)")
        } else {
            print("Saved successfully!")
        }
    }
}
#endif

#Preview {
    ContentView()
}
