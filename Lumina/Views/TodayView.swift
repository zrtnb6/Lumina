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
                    VStack(spacing: 18) {
                        // 主标题——去掉 Lumina 双重标题，只保留一行
                        Text("今日流光")
                            .font(.title.bold())
                            .foregroundStyle(.white)
                            .padding(.top, 8)

                        MoodOrbsView(selected: $selectedMood) { _ in
                            haptic()
                        }

                        JournalCard(note: $noteText, focus: $focusText)

                        // 可形变的玻璃操作区：保存 / 分享 / 展开
                        GlassEffectContainer(spacing: 12) {
                            HStack(spacing: 12) {
                                Button {
                                    saveEntry()
                                } label: {
                                    Label("保存此刻", systemImage: "checkmark.seal.fill")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
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
                                            .padding(.vertical, 10)
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
                                        .frame(width: 44, height: 44)
                                }
                                .glassEffect(.regular.interactive(), in: Circle())
                                .glassEffectID("toggle", in: ns)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .frame(maxWidth: 540)
                    .padding(.horizontal)
                    .padding(.bottom, 80) // tab bar(~49) + 安全区余量
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
