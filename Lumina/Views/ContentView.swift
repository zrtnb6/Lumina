import SwiftUI

private enum Tab: Hashable {
    case today
    case history
    case settings
}

struct ContentView: View {
    @State private var selectedTab: Tab = .today

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem { Label("今日", systemImage: "sun.max.fill") }
                .tag(Tab.today)

            HistoryView(onGoToToday: { selectedTab = .today })
                .tabItem { Label("流光", systemImage: "calendar") }
                .tag(Tab.history)

            SettingsView()
                .tabItem { Label("设置", systemImage: "gearshape") }
                .tag(Tab.settings)
        }
        // iOS 26 会自动为 TabBar 套上 Liquid Glass 浮条
    }
}
