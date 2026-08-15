import SwiftUI

/// 日记 / 焦点输入卡片：一张浮在渐变背景上的玻璃面板
/// 紧凑布局，适配手机纵向空间有限的现实。
struct JournalCard: View {
    @Binding var note: String
    @Binding var focus: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("此刻心情")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)

            TextEditor(text: $note)
                .frame(minHeight: 56, maxHeight: 96) // 比之前 68→140 更紧凑
                .scrollContentBackground(.hidden)
                .foregroundStyle(.white)

            Color.white.opacity(0.18)
                .frame(height: 1)

            Text("今日焦点")
                .font(.caption.weight(.medium))
                .foregroundStyle(.white.opacity(0.85))

            TextField("一句话目标…", text: $focus)
                .textFieldStyle(.plain)
                .foregroundStyle(.white)
                .font(.subheadline)
        }
        .padding(14) // 从 16 → 14
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 22))
    }
}
