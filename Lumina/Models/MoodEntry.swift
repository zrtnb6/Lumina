import Foundation

struct MoodEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    let moodRaw: String
    var note: String
    var focus: String

    init(id: UUID = UUID(), createdAt: Date = Date(), mood: Mood, note: String = "", focus: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.moodRaw = mood.rawValue
        self.note = note
        self.focus = focus
    }

    var mood: Mood {
        Mood(rawValue: moodRaw) ?? .calm
    }
}
