import SwiftUI

struct HoverIconButton: View {
    @State private var isHovered = false
    private let onTap: () -> Void
    private var systemName: String
    private var size: CGFloat
        
    init(onTap: @escaping () -> Void, systemName: String, size: CGFloat = 16) {
        self.onTap = onTap
        self.systemName = systemName
        self.size = size
    }
    
    var body: some View {
        Button(action: onTap) {
            Image(systemName: systemName)
                .font(.system(size: size, weight: .medium))
                .foregroundColor(isHovered ? Color.point : Color.subText)
                .frame(width: 32, height: 32)
                .background(Color.background)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}

#Preview {
    HoverIconButton(onTap: {}, systemName: "plus")
        .padding()
} 
