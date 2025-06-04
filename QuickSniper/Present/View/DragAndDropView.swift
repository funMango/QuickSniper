//  HorizontalDragDropCards.swift — 드래그 시 카드가 밀리고, 드롭 후 정확히 확정되는 최종 버전
//  * 한 줄 가로 스크롤 + HStack
//  * 실시간 밀림 애니메이션(placeholder 사용 X, 실제 배열 재배치)
//  * 드롭 확정 후 카드가 합쳐지거나 중복되지 않음
//  Xcode 15 / Swift 5.9 이상에서 바로 컴파일

import SwiftUI
import UniformTypeIdentifiers

// MARK: - Model --------------------------------------------------------
struct DraggableCard: Identifiable, Equatable, Codable {
    let id: UUID
    var label: String
    init(id: UUID = .init(), label: String) { self.id = id; self.label = label }
}

// MARK: - ViewModel ----------------------------------------------------
final class CardListViewModel: ObservableObject {
    @Published var cards: [DraggableCard] = [
        .init(label: "A"), .init(label: "B"), .init(label: "C"), .init(label: "D")
    ]

    /// 카드 재배치(공통): from, to 인덱스를 받아 안전하게 이동
    private func moveElement(from: Int, to: Int) {
        var tmp = cards
        let mover = tmp.remove(at: from)
        let insertAt = from < to ? to - 1 : to            // 핵심 보정! (앞→뒤 한 칸 엇나감 해결)
        tmp.insert(mover, at: insertAt)
        withAnimation(.spring()) { cards = tmp }
    }

    // 실시간 밀림 (hover)
    func reorderDuringDrag(dragId: UUID, over targetId: UUID) {
        guard dragId != targetId,
              let from = cards.firstIndex(where: { $0.id == dragId }),
              let to   = cards.firstIndex(where: { $0.id == targetId }) else { return }
        moveElement(from: from, to: to)
    }

    // 드롭 확정
    func commitMove(dragId: UUID, to targetId: UUID) {
        guard dragId != targetId,
              let from = cards.firstIndex(where: { $0.id == dragId }),
              let to   = cards.firstIndex(where: { $0.id == targetId }) else { return }
        moveElement(from: from, to: to)
    }
}

// MARK: - Single Card Cell -------------------------------------------
struct CardCell: View {
    let card: DraggableCard
    let utType = UTType.plainText            // UUID 문자열 전송
    @Binding var draggingId: UUID?
    @ObservedObject var vm: CardListViewModel

    @State private var isHovering = false

    var body: some View {
        CardView(label: card.label)
            .opacity(card.id == draggingId ? 0.25 : 1)
            .scaleEffect(card.id == draggingId ? 1.07 : 1)
            // ─ drag : uuid 문자열 전송 ─
            .onDrag {
                draggingId = card.id
                return NSItemProvider(object: card.id.uuidString as NSString)
            }
            // ─ drop (hover + perform) 한 번만 ─
            .onDrop(of: [utType.identifier], isTargeted: $isHovering) { providers in
                // perform (드롭 확정)
                guard let first = providers.first else { return false }
                first.loadObject(ofClass: NSString.self) { obj, _ in
                    guard let uuidStr = obj as? String,
                          let dragged = UUID(uuidString: uuidStr) else { return }
                    DispatchQueue.main.async {
                        vm.commitMove(dragId: dragged, to: card.id)
                        draggingId = nil
                    }
                }
                return true
            }
            // ─ hover 변화 → 즉시 밀림 ─
            .onChange(of: isHovering) { hovering in
                guard hovering, let drag = draggingId, drag != card.id else { return }
                vm.reorderDuringDrag(dragId: drag, over: card.id)
            }
    }
}

// MARK: - Main View ----------------------------------------------------
struct HorizontalDragDropCards: View {
    @StateObject private var vm = CardListViewModel()
    @State private var draggingId: UUID?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 16) {
                ForEach(vm.cards) { card in
                    CardCell(card: card, draggingId: $draggingId, vm: vm)
                }
            }
            .padding()
            .frame(height: 180)
        }
    }
}

// MARK: - Card Visual --------------------------------------------------
struct CardView: View {
    let label: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).fill(Color.blue)
                .frame(width: 100, height: 150)
                .shadow(radius: 4)
            Text(label).font(.largeTitle).bold().foregroundStyle(.white)
        }
    }
}

// MARK: - Preview ------------------------------------------------------
#Preview { HorizontalDragDropCards() }
