import SwiftUI

extension Color {
    init(hex: UInt32, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

enum Mood: String, CaseIterable, Codable, Identifiable {
    case calm
    case happy
    case focused
    case tired
    case energetic

    var id: String { rawValue }

    var title: String {
        switch self {
        case .calm: "平静"
        case .happy: "愉悦"
        case .focused: "专注"
        case .tired: "疲惫"
        case .energetic: "活力"
        }
    }

    var systemImage: String {
        switch self {
        case .calm: "leaf.fill"
        case .happy: "sun.max.fill"
        case .focused: "target"
        case .tired: "moon.fill"
        case .energetic: "bolt.fill"
        }
    }

    /// 每种情绪对应一组渐变色，玻璃面板会折射它
    var gradient: [Color] {
        switch self {
        case .calm:      [Color(hex: 0x5B6CFF), Color(hex: 0x9B5DE5)]
        case .happy:     [Color(hex: 0xFF8A5B), Color(hex: 0xFF5DA2)]
        case .focused:   [Color(hex: 0x2D9CDB), Color(hex: 0x56CCF2)]
        case .tired:     [Color(hex: 0x4B4B6B), Color(hex: 0x6B6B8B)]
        case .energetic: [Color(hex: 0xFF4D4D), Color(hex: 0xFF9F1C)]
        }
    }
}

extension Date {
    func relativeDay() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) { return "今天" }
        if calendar.isDateInYesterday(self) { return "昨天" }
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        return formatter.string(from: self)
    }

    func timeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
