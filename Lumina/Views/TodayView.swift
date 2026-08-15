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
        // 用真实屏幕尺寸按比例分配各区块 —— 不再写死 padding
        GeometryReader { geo in
            let h = geo.size.height
            let safeTop = geo.safeAreaInsets.top
            let safeBottom = geo.safeAreaInsets.bottom
            // iOS 26 Liquid Glass TabBar 浮条 ~70pt + safe bottom；至少留 90pt
            let tabBarSpace: CGFloat = max(90, safeBottom + 70)

            // 固定段高度合计：caption + spacing + title + spacing + orbs + spacing + actions
            let captionH: CGFloat = 20
            let titleH: CGFloat = 30
            let orbsH: CGFloat = 74
            let actionsH: CGFloat = 48
            let gaps: CGFloat = 8 + 10 + 12 + 12 // caption→title→orbs→actions
            let fixedTotal: CGFloat = captionH + titleH + orbsH + actionsH + gaps + tabBarSpace + 8

            // JournalCard 内部固定段：title + divider + focus label + focus field + padding
            let cardInner: CGFloat = 18 + 6 + 1 + 6 + 16 + 6 + 28 + 14 * 2 // ≈ 111
            // 弹性：TextEditor 高度 = 剩余空间，封顶 160、最低 80
            let editorH: CGFloat = min(160, max(80, h - fixedTotal - cardInner))
            let cardH: CGFloat = editorH + cardInner

            ZStack(alignment: .top) {
                LinearGradient(
                    colors: selectedMood.gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.8), value: selectedMood)

                ScrollView {
                    VStack(spacing: 0) {
                        Text("Lumina")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.white.opacity(0.7))
                            .frame(height: captionH)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                            .padding(.top, safeTop > 0 ? 0 : 4)

                        Text("今日流光")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .frame(height: titleH)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                            .padding(.top, 8)

                        MoodOrbsView(selected: $selectedMood) { _ in
                            haptic()
                        }
                        .frame(height: orbsH)
                        .padding(.top, 12)
                        .padding(.horizontal, 16)

                        JournalCard(note: $noteText, focus: $focusText, editorHeight: editorH)
                            .frame(height: cardH)
                            .padding(.top, 12)
                            .padding(.horizontal, 16)

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
                            .frame(height: actionsH)
                            .padding(.horizontal, 16)
                        }
                        .padding(.top, 12)

                        Spacer(minLength: tabBarSpace)
                    }
                    .frame(maxWidth: 540)
                    .frame(maxWidth: .infinity)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            // 不用 NavigationStack —— 没有 nav bar 就不会出顶部黑条
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