import Foundation
import Observation

/// 本地 JSON 持久化存储（无需 iCloud / Core Data，纯原生、零外部依赖）
@MainActor
@Observable
final class LuminaStore {
    private(set) var entries: [MoodEntry] = []
    private let fileURL: URL

    init() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.fileURL = documents.appendingPathComponent("lumina_entries.json")
        load()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) else {
            entries = []
            return
        }
        entries = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    func add(_ entry: MoodEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func delete(_ entry: MoodEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }
}
