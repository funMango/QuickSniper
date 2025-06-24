//
//  WelcomeContext.swift
//  QuickSniper
//
//  Created by 이민호 on 6/24/25.
//

import Foundation

struct WelcomeContext {
    static let korean = """
        빠르고 스마트한 작업을 위한 완벽한 도구

        시작해보세요
        - 단축키 하나로 언제든 Shifty를 호출하세요 (Ctrl + z)
        - 단축키는 상단 메뉴바에서 환경설정을 통해 변경할 수 있습니다.
        - 스니펫으로 자주 사용하는 텍스트를 저장하고 빠르게 복사하세요
        - 파일 북마크로 즐겨찾는 파일, 앱에 바로 접근하세요

        팁
        - 한번 클릭: 파일, 폴더 선택
        - 두번 클릭: 파일 열기
        - 오른쪽 클릭: 파일, 폴더 옵션 선택
        - 길게 클릭: 파일, 폴더 순서 변경
    """
    
    static let english = """
        Your perfect tool for fast and smart work

        Get Started
        - Summon Shifty instantly with a single keystroke (Ctrl + z)
        - You can change the shortcut through Preferences in the top menu bar
        - Save frequently used text as snippets for quick copying
        - Bookmark your favorite files and apps for instant access

        Pro Tips
        - Single click: Select files/folders
        - Double click: Open files
        - Right click: Show options menu
        - Long press: Drag to reorder
    """
    
    static var current: String {
        let isKorean = Locale.current.language.languageCode?.identifier == "ko"
        return isKorean ? korean : english
    }
}
