import SwiftUI

struct TextInput: View {
    let placeholder: String?
    @Binding var text: String

    var body: some View {
        TextField(placeholder ?? "", text: $text)
            .textFieldStyle(.plain)
            .font(.system(size: 16))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(NSColor.separatorColor), lineWidth: 0.5)
            )
    }
}

#Preview {
    TextInput(placeholder: "text", text: .constant(""))
}
