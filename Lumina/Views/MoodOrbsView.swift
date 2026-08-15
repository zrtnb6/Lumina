import SwiftUI

/// 情绪选择：悬浮的玻璃球。整组包在 GlassEffectContainer 中，
/// 相邻玻璃会自动相互折射、融合。
///
/// 球直径按可用宽度自适应（封顶 76、兜底 52），
/// 在从 SE 到 Pro Max 的所有屏幕上都饱满不溢出。
struct MoodOrbsView: View {
    @Binding var selected: Mood
    let onPick: (Mood) -> Void

    var body: some View {
        GeometryReader { geo in
            let count = CGFloat(Mood.allCases.count)
            let spacing: CGFloat = 10
            // 更紧凑：小屏至少 48，大屏不超过 66，给标题/按钮让出垂直空间
            let diameter = min(66, max(48, (geo.size.width - spacing * (count - 1)) / count))

            HStack(spacing: spacing) {
                ForEach(Mood.allCases) { mood in
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selected = mood
                        }
                        onPick(mood)
                    } label: {
                        Image(systemName: mood.systemImage)
                            .font(.system(size: diameter * 0.40, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: diameter, height: diameter)
                    }
                    .glassEffect(.regular.interactive(), in: Circle())
                    .scaleEffect(selected == mood ? 1.14 : 1.0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 74) // 容纳最大球径(66)+间距余量
    }
}
