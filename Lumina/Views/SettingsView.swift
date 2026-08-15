import SwiftUI
import UIKit

struct SettingsView: View {
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("keepScreenOn") private var keepScreenOn = false

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                ScrollView {
                    VStack(spacing: 18) {
                        settingsCard
                    }
                    .padding()
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear { applyScreenAwake() }
        .onChange(of: keepScreenOn) { _ in applyScreenAwake() }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [Color(hex: 0x101024), Color(hex: 0x1A1530)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var settingsCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Group {
                Toggle("触感反馈", isOn: $hapticsEnabled)
                Divider().background(Color.white.opacity(0.15))
                Toggle("保持屏幕常亮", isOn: $keepScreenOn)
            }
            .tint(Color(hex: 0x8A6BFF))
            .foregroundStyle(.white)

            Divider()
                .background(Color.white.opacity(0.15))
                .padding(.vertical, 8)

            VStack(alignment: .leading, spacing: 6) {
                Text("关于 Lumina")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("流光 · 情绪日记与每日焦点。\n全程采用 Apple 官方 Liquid Glass 液态玻璃设计，iOS 26 原生体验。")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(22)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 26))
    }

    private func applyScreenAwake() {
        UIApplication.shared.isIdleTimerDisabled = keepScreenOn
    }
}
