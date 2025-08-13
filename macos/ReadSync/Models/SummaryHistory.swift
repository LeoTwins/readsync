import Foundation

struct SummaryHistory: Codable, Identifiable {
    let id: UUID
    let title: String
    let url: String
    let requestedAt: Date
    let status: SummaryStatus
    
    init(id: UUID = UUID(), title: String, url: String, requestedAt: Date, status: SummaryStatus) {
        self.id = id
        self.title = title
        self.url = url
        self.requestedAt = requestedAt
        self.status = status
    }
}

enum SummaryStatus: String, Codable, CaseIterable {
    case processing = "processing"
    case completed = "completed"
    
    var displayText: String {
        switch self {
        case .processing:
            return "要約中"
        case .completed:
            return "完了"
        }
    }
}