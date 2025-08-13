import SwiftUI

struct URLInputView: View {
    @StateObject private var viewModel = URLInputViewModel()
    @State var url: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // TitleBar領域に配置するTextInput
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 8)
                
                TextInput(placeholder: "https://example.com", text: $url)
                    .padding(.horizontal, 16)
                
                Spacer()
                    .frame(height: 12)
            }
            .padding(.top, 10)
            .frame(height: 52)
            
            // 履歴表示エリア
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.historySections) { section in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(section.title)
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            ForEach(section.items) { item in
                                HistoryItemView(item: item)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all, edges: .top)
    }
}

struct HistoryItemView: View {
    let item: SummaryHistory
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.body)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(item.url)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Circle()
                    .fill(item.status == .completed ? Color.green : Color.orange)
                    .frame(width: 6, height: 6)
                
                Text(item.status.displayText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(NSColor.separatorColor), lineWidth: 0.5)
        )
    }
}
