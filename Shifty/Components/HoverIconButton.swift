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
                .foregroundColor(Color.subText)
                .frame(width: size + 10, height: size + 10)
                .background {
                    if isHovered {
                        Circle()
                            .fill(Color.buttonHover)
                            .animation(.easeInOut(duration: 0.2), value: isHovered)
                    } else {
                        Color.clear
                    }
                }
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
