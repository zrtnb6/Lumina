import SwiftUI

struct HistoryView: View {
    @Environment(LuminaStore.self) private var store
    let onGoToToday: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                content
            }
            .navigationTitle("流光")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [Color(hex: 0x14142B), Color(hex: 0x1F1B3A)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    @ViewBuilder
    private var content: some View {
        if store.entries.isEmpty {
            emptyState
        } else {
            entriesList
        }
    }

    private var emptyState: some View {
        VStack(spacing: 18) {
            Image(systemName: "sparkles")
                .font(.system(size: 44))
                .foregroundStyle(.white.opacity(0.85))
            Text("还没有记录")
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text("在「今日」写下你的第一缕流光")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))

            GlassButton(title: "去记录", systemImage: "arrow.right") {
                onGoToToday()
            }
            .padding(.top, 8)
        }
        .padding()
    }

    private var entriesList: some View {
        List {
            ForEach(store.entries) { entry in
                HistoryRow(entry: entry)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation { store.delete(entry) }
                        } label: {
                            Label("删除", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

private struct HistoryRow: View {
    let entry: MoodEntry

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: entry.mood.systemImage)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(Circle().fill(entry.mood.gradient.first?.opacity(0.55) ?? Color.white))

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(entry.mood.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Spacer()
                    Text("\(entry.createdAt.relativeDay()) \(entry.createdAt.timeString())")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
                if !entry.note.isEmpty {
                    Text(entry.note)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.88))
                        .lineLimit(3)
                }
                if !entry.focus.isEmpty {
                    Text("焦点 · \(entry.focus)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
        }
        .padding(16)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 22))
    }
}
