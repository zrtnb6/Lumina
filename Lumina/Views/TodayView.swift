import SwiftUI
import UIKit

struct TodayView: View {
    @Environment(LuminaStore.self) private var store
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true

    @State private var selectedMood: Mood = .calm
    @State private var noteText: String = ""
    @State private var focusText: String = ""
    @State private var showShare = false
    @State private var showShareSheet = false
    @State private var shareText: String = ""

    @Namespace private var ns

    var body: some View {
        NavigationStack {
            ZStack {
                // 动态渐变背景——玻璃面板会实时折射它
                LinearGradient(colors: selectedMood.gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.8), value: selectedMood)

                ScrollView {
                    VStack(spacing: 26) {
                        // 内容最大宽度约束：大屏不摊开、小屏占满，整体比例更稳
                        Text("今日流光")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                            .padding(.top, 12)

                        MoodOrbsView(selected: $selectedMood) { _ in
                            haptic()
                        }

                        JournalCard(note: $noteText, focus: $focusText)

                        // 可形变的玻璃操作区：保存 / 分享 / 展开
                        // 胶囊按钮用 maxWidth 自动均分剩余空间，圆形按钮固定，
                        // 这样在任意屏宽下都不会溢出或被裁切。
                        GlassEffectContainer(spacing: 14) {
                            HStack(spacing: 14) {
                                Button {
                                    saveEntry()
                                } label: {
                                    Label("保存此刻", systemImage: "checkmark.seal.fill")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                }
                                .glassEffect(.regular, in: Capsule())
                                .glassEffectID("save", in: ns)

                                if showShare {
                                    Button {
                                        shareEntry()
                                    } label: {
                                        Label("分享", systemImage: "square.and.arrow.up")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                    }
                                    .glassEffect(.regular, in: Capsule())
                                    .glassEffectID("share", in: ns)
                                    .transition(.scale.combined(with: .opacity))
                                }

                                Button {
                                    withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                                        showShare.toggle()
                                    }
                                    haptic()
                                } label: {
                                    Image(systemName: showShare ? "xmark" : "ellipsis")
                                        .font(.title3)
                                        .foregroundStyle(.white)
                                        .frame(width: 48, height: 48)
                                }
                                .glassEffect(.regular.interactive(), in: Circle())
                                .glassEffectID("toggle", in: ns)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .frame(maxWidth: 540)
                    .padding(.horizontal)
                    .padding(.bottom, 56)
                }
            }
            .navigationTitle("Lumina")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [shareText])
        }
    }

    private func saveEntry() {
        let entry = MoodEntry(mood: selectedMood, note: noteText, focus: focusText)
        store.add(entry)
        shareText = "\(entry.mood.title) · \(entry.createdAt.relativeDay()) \(entry.createdAt.timeString())\n\(entry.note)\n—— 来自 Lumina 流光日记"
        withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
            showShare = true
        }
        noteText = ""
        focusText = ""
        haptic()
    }

    private func shareEntry() {
        showShareSheet = true
    }

    private func haptic() {
        guard hapticsEnabled else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
