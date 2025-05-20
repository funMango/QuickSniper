//
//  SidePanel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import SwiftUI

struct Snippet: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}

struct PanelView: View {
    let snippets: [Snippet] = [
        .init(title: "일본 한국예약 리터치 안내", body: """
            はい！6月1日15:00でリタッチ予約を確定いたします！

            下記リタッチ予約の案内文をお送りいたします☺️

            [リタッチ予約のご案内文]

            ▫️日時 : 6/1 15:00
            ▫️住所:江南区駅三洞652-6(ボンウンサロ38ギル4)ミュービル5階(ナヌンイ、アミスキン医院 建物)


            ▪️ 他の予約を受けずに無料でさせていただく 
            レタッチサービスにより遅刻、当日キャンセル、ノーショーはレタッチサービス消滅となります。 （ノーショー後の再予約の際には有料のリタッチに切り替わります。）

            ️️ ▪️ 予約の変更は1回のみ可能です。(予約前日·当日は予約の変更ができません。)

            *駐車不可、駅三洞は車がいつも混んでいる場所です。 公共交通機関のご利用をお勧めし、余裕を持ってご到着ください。

            * 15分以上遅れると、後に予約時間が延期されるため、「到着されても施術が不可」となります。 予約時間を必ず守ってください。

            *予約者以外は同伴出入り不可
            *アイライン • 涙袋の所要時間:各項目当たり最大1時間
        """),
        .init(title: "교착 상태 4조건", body: "1. 상호배제 2. 점유와 대기 3. 비선점 4. 환형 대기\n이 조건이 모두 만족될 때 교착상태가 발생한다."),
        .init(title: "패스키 흐름", body: "패스키는 사용자 단말에 비공개키를 저장하고, 공개키는 서버에 등록한다. WebAuthn은 이를 기반으로 인증 흐름을 수행한다..."),
        .init(title: "Fork vs Exec", body: "fork는 부모를 복사하고 exec은 새로운 프로그램을 덮어씌운다. 시스템 콜과 메모리 모델에서 차이가 있으며..."),
        .init(title: "교착 상태 4조건", body: "1. 상호배제 2. 점유와 대기 3. 비선점 4. 환형 대기\n이 조건이 모두 만족될 때 교착상태가 발생한다."),
        .init(title: "패스키 흐름", body: "패스키는 사용자 단말에 비공개키를 저장하고, 공개키는 서버에 등록한다. WebAuthn은 이를 기반으로 인증 흐름을 수행한다..."),
        .init(title: "Fork vs Exec", body: "fork는 부모를 복사하고 exec은 새로운 프로그램을 덮어씌운다. 시스템 콜과 메모리 모델에서 차이가 있으며..."),
        .init(title: "교착 상태 4조건", body: "1. 상호배제 2. 점유와 대기 3. 비선점 4. 환형 대기\n이 조건이 모두 만족될 때 교착상태가 발생한다."),
        .init(title: "패스키 흐름", body: "패스키는 사용자 단말에 비공개키를 저장하고, 공개키는 서버에 등록한다. WebAuthn은 이를 기반으로 인증 흐름을 수행한다..."),
        .init(title: "Fork vs Exec", body: "fork는 부모를 복사하고 exec은 새로운 프로그램을 덮어씌운다. 시스템 콜과 메모리 모델에서 차이가 있으며..."),
        .init(title: "교착 상태 4조건", body: "1. 상호배제 2. 점유와 대기 3. 비선점 4. 환형 대기\n이 조건이 모두 만족될 때 교착상태가 발생한다."),
        .init(title: "패스키 흐름", body: "패스키는 사용자 단말에 비공개키를 저장하고, 공개키는 서버에 등록한다. WebAuthn은 이를 기반으로 인증 흐름을 수행한다..."),
        .init(title: "Fork vs Exec", body: "fork는 부모를 복사하고 exec은 새로운 프로그램을 덮어씌운다. 시스템 콜과 메모리 모델에서 차이가 있으며..."),
        .init(title: "교착 상태 4조건", body: "1. 상호배제 2. 점유와 대기 3. 비선점 4. 환형 대기\n이 조건이 모두 만족될 때 교착상태가 발생한다."),
        .init(title: "패스키 흐름", body: "패스키는 사용자 단말에 비공개키를 저장하고, 공개키는 서버에 등록한다. WebAuthn은 이를 기반으로 인증 흐름을 수행한다...")
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(alignment: .top, spacing: 12) {
                ForEach(snippets) { snippet in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(snippet.title)
                            .font(.headline)
                        Text(snippet.body)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(5)
                    }
                    .padding()
                    .frame(width: 240, alignment: .leading)
                    .background(.regularMaterial)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .background(
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
        )
    }
}

#Preview {
    PanelView()
}
