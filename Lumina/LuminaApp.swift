import SwiftUI

@main
struct LuminaApp: App {
    @State private var store = LuminaStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
                .preferredColorScheme(.dark)
        }
    }
}
