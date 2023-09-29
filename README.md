# swift-deeplinking

## Usage

```swift
// #1: Define your deeplink type
enum Deeplink: Deeplinkable {
    case detail
}

// #2: Create a DeeplinkManager and add it to the SwiftUI environment
// #3: Add a `onOpenURL` modifier to forward incoming URLs to the DeeplinkManager
@main
struct MyApp: App {
    @StateObject private var deeplinkManager = DeeplinkManager()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .environment(deeplinkManager)
        .onOpenURL { url in
            if let deeplink = Deeplink(url: url) {}
                deeplinkManager.handle(deeplink)
            }
        }
    }
}

// #4: Add `onOpenDeeplink` handlers throughout your app
struct HomeView: View {
    @State private showDetail = false

    var body: some View {
        Button("Open detail") {
            showDetail = true
        }
        .onOpenDeeplink { deeplink in
            switch deeplink {
                case Deeplinkable.detail:
                    showDetail = true
                    return .handled
                default:
                    return .notHandled
            }
        }
    }
}
```