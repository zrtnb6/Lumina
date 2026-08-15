import SwiftUI

/// 日记 / 焦点输入卡片：浮在渐变背景上的玻璃面板
/// editorHeight 由父视图按真实屏幕可用空间算出，保证任何机型都不溢出
struct JournalCard: View {
    @Binding var note: String
    @Binding var focus: String
    var editorHeight: CGFloat = 96

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("此刻心情")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)

            TextEditor(text: $note)
                .frame(height: editorHeight)
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
        .padding(14)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 22))
    }
}