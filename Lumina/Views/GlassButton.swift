import SwiftUI

/// 通用玻璃按钮（次要操作）。使用 iOS 26 官方 .glass 按钮样式。
struct GlassButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
        }
        .buttonStyle(.glass)
    }
}
