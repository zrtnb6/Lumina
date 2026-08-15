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
            ZStack(alignment: .top) {
                // 动态渐变背景——玻璃面板会实时折射它
                LinearGradient(
                    colors: selectedMood.gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.8), value: selectedMood)

                ScrollView {
                    VStack(spacing: 16) {
                        // 主标题——只一行，nav bar 上 inline 再放一个 "Lumina" 小字
                        Text("今日流光")
                            .font(.title2.bold()) // 标题字重对，但字阶 title2 ≈ 22pt，更紧凑
                            .foregroundStyle(.white)
                            .padding(.top, 4)

                        MoodOrbsView(selected: $selectedMood) { _ in
                            haptic()
                        }

                        JournalCard(note: $noteText, focus: $focusText)

                        // 可形变的玻璃操作区：保存 / 分享 / 展开
                        GlassEffectContainer(spacing: 12) {
                            HStack(spacing: 10) {
                                Button {
                                    saveEntry()
                                } label: {
                                    Label("保存此刻", systemImage: "checkmark.seal.fill")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                }
                                .glassEffect(.regular, in: Capsule())
                                .glassEffectID("save", in: ns)

                                if showShare {
                                    Button {
                                        shareEntry()
                                    } label: {
                                        Label("分享", systemImage: "square.and.arrow.up")
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
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
                                        .font(.body.weight(.semibold))
                                        .foregroundStyle(.white)
                                        .frame(width: 40, height: 40)
                                }
                                .glassEffect(.regular.interactive(), in: Circle())
                                .glassEffectID("toggle", in: ns)
                            }
                            .padding(.horizontal)
                        }

                        Spacer(minLength: 8)
                    }
                    .frame(maxWidth: 540)
                    .frame(maxWidth: .infinity) // 让 maxWidth:540 在 iPad 也居中不影响
                    .padding(.horizontal)
                    // 用 safeAreaInset 让底部 padding 跟随真实 tab bar 高度，不会把内容顶得靠上
                    .padding(.bottom, 24)
                }
                .scrollDismissesKeyboard(.interactively)
                // 让 ScrollView 把 nav bar 算进 inset，避免内容被标题盖住
                .contentMargins(.top, 0, for: .scrollContent)
            }
            .navigationTitle("Lumina")
            .navigationBarTitleDisplayMode(.inline)
            // 让 TabBar 透明浮条自己走 safe area，但 ScrollView 内容不会被它遮
            .toolbarBackground(.hidden, for: .navigationBar)
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
