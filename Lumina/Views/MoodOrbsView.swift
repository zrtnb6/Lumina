import SwiftUI

/// 情绪选择：悬浮的玻璃球。整组包在 GlassEffectContainer 中，
/// 相邻玻璃会自动相互折射、融合。
///
/// 关键点：球直径不再写死，而是按当前可用宽度自适应
/// （封顶 66、兜底 46），这样从最小屏到 Pro Max 都不会溢出或被裁切。
struct MoodOrbsView: View {
    @Binding var selected: Mood
    let onPick: (Mood) -> Void

    var body: some View {
        GeometryReader { geo in
            let count = CGFloat(Mood.allCases.count)
            let spacing: CGFloat = 10
            // 实际可用宽度里，均分给每个球；大屏封顶、小屏兜底
            let diameter = min(66, max(46, (geo.size.width - spacing * (count - 1)) / count))

            HStack(spacing: spacing) {
                ForEach(Mood.allCases) { mood in
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selected = mood
                        }
                        onPick(mood)
                    } label: {
                        Image(systemName: mood.systemImage)
                            .font(.system(size: diameter * 0.42, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: diameter, height: diameter)
                    }
                    .glassEffect(.regular.interactive(), in: Circle())
                    .scaleEffect(selected == mood ? 1.16 : 1.0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 72)
    }
}
