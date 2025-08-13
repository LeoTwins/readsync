import Foundation

final class URLInputViewModel: ObservableObject {
    @Published var historySections: [HistorySection] = []
    
    struct HistorySection: Identifiable {
        let id = UUID()
        let title: String
        let items: [SummaryHistory]
    }
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
        let mockHistories = createMockHistories()
        historySections = groupByDate(mockHistories)
    }
    
    private func createMockHistories() -> [SummaryHistory] {
        let calendar = Calendar.current
        let now = Date()
        
        return [
            // Today
            SummaryHistory(
                title: "SwiftUIでMVVMパターンを実装する方法",
                url: "https://example.com/swiftui-mvvm",
                requestedAt: calendar.date(byAdding: .hour, value: -2, to: now)!,
                status: .completed
            ),
            SummaryHistory(
                title: "iOS開発のベストプラクティス",
                url: "https://example.com/ios-best-practices",
                requestedAt: calendar.date(byAdding: .hour, value: -1, to: now)!,
                status: .processing
            ),
            
            // Yesterday
            SummaryHistory(
                title: "Combineフレームワークの基礎",
                url: "https://example.com/combine-basics",
                requestedAt: calendar.date(byAdding: .day, value: -1, to: now)!,
                status: .completed
            ),
            
            // Older
            SummaryHistory(
                title: "SwiftUIアニメーションガイド",
                url: "https://example.com/swiftui-animations",
                requestedAt: calendar.date(byAdding: .day, value: -3, to: now)!,
                status: .completed
            ),
            SummaryHistory(
                title: "Core Dataを使ったデータ管理",
                url: "https://example.com/core-data",
                requestedAt: calendar.date(byAdding: .day, value: -5, to: now)!,
                status: .completed
            )
        ]
    }
    
    private func groupByDate(_ histories: [SummaryHistory]) -> [HistorySection] {
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: histories) { history in
            if calendar.isDateInToday(history.requestedAt) {
                return "Today"
            } else if calendar.isDateInYesterday(history.requestedAt) {
                return "Yesterday"
            } else {
                return "Older"
            }
        }
        
        var sections: [HistorySection] = []
        
        if let todayItems = grouped["Today"] {
            sections.append(HistorySection(title: "Today", items: todayItems.sorted { $0.requestedAt > $1.requestedAt }))
        }
        
        if let yesterdayItems = grouped["Yesterday"] {
            sections.append(HistorySection(title: "Yesterday", items: yesterdayItems.sorted { $0.requestedAt > $1.requestedAt }))
        }
        
        if let olderItems = grouped["Older"] {
            sections.append(HistorySection(title: "Older", items: olderItems.sorted { $0.requestedAt > $1.requestedAt }))
        }
        
        return sections
    }
}
