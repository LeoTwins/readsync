import SwiftUI

@main
struct ReadSyncApp: App {
    @StateObject private var menuBarService = MenuBarService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
