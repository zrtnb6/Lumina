import SwiftUI

/// 情绪选择：悬浮的玻璃球。整组包在 GlassEffectContainer 中，
/// 相邻玻璃会自动相互折射、融合。
struct MoodOrbsView: View {
    @Binding var selected: Mood
    let onPick: (Mood) -> Void

    @Namespace private var ns

    var body: some View {
        GlassEffectContainer(spacing: 16) {
            HStack(spacing: 16) {
                ForEach(Mood.allCases) { mood in
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selected = mood
                        }
                        onPick(mood)
                    } label: {
                        Image(systemName: mood.systemImage)
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 56, height: 56)
                    }
                    .glassEffect(.regular.interactive(), in: Circle())
                    .scaleEffect(selected == mood ? 1.18 : 1.0)
                }
            }
        }
    }
}
