//
//  FaviconManager.swift
//  Shifty
//
//  Created by 이민호 on 6/27/25.
//

import Foundation
import AppKit // macOS에서 NSImage, NSBitmapImageRep 등을 사용하기 위해 import

struct FaviconManager {
    // 파비콘을 가져오고 필요에 따라 최적화하는 함수
    func fetchFavicon(for url: URL, completion: @escaping (Data?) -> Void) {
        guard let host = url.host else {
            completion(nil)
            return
        }

        // Google Favicon API URL 구성 (약간 더 큰 사이즈 요청하여 리사이즈할 여지 확보)
        // macOS 아이콘은 보통 16x16, 32x32, 64x64, 128x128 등이 사용됩니다.
        // 여기서는 좀 더 큰 128px를 요청하고, 아래에서 64x64로 리사이즈해볼게요.
        let faviconApiUrlString = "https://www.google.com/s2/favicons?domain=\(host)&sz=128"
        guard let apiUrl = URL(string: faviconApiUrlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: apiUrl) { data, response, error in
            guard let data = data, error == nil,
                  let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(nil)
                return
            }
            
            // --- 최적화 로직 추가 ---
            // macOS에서는 파비콘으로 64x64 또는 32x32가 적절합니다.
            // 여기서는 64x64로 리사이즈 및 PNG로 저장 (투명도 유지)
            // outputFormat 매개변수 제거 및 .png 고정
            let optimizedData = self.optimizeImageData(data, targetSize: CGSize(width: 64, height: 64))
            // --- 최적화 로직 끝 ---
            
            completion(optimizedData) // 최적화된 데이터 반환
        }.resume()
    }

    // MARK: - 이미지 최적화 헬퍼 메서드
    
    /// 주어진 이미지 데이터를 최적화하여 Data 형태로 반환합니다.
    /// - Parameters:
    ///   - imageData: 원본 이미지 데이터 (Data).
    ///   - targetSize: 이미지를 리사이즈할 목표 크기. (0,0)이면 리사이즈 안 함.
    ///   - compressionQuality: JPEG 압축 품질 (0.0 ~ 1.0). 이 함수에서는 PNG만 생성하므로 이 매개변수는 더 이상 사용되지 않습니다.
    /// - Returns: 최적화된 이미지 데이터 (Data?), 실패 시 nil.
    private func optimizeImageData(_ imageData: Data, targetSize: CGSize) -> Data? {
        
        // NSImage로 변환 시도
        guard let originalImage = NSImage(data: imageData) else { return nil }
        
        var processedImage = originalImage
        
        // 1. 리사이즈 (targetSize가 유효할 경우)
        if targetSize.width > 0 && targetSize.height > 0 &&
            (originalImage.size.width > targetSize.width || originalImage.size.height > targetSize.height) {
            
            let targetRect = NSMakeRect(0, 0, targetSize.width, targetSize.height)
            let newImage = NSImage(size: targetSize)
            
            // 이미지 렌더링 컨텍스트 시작
            newImage.lockFocus()
            // 원본 이미지를 새 이미지의 목표 크기에 맞게 그립니다.
            originalImage.draw(in: targetRect, from: NSZeroRect, operation: .sourceOver, fraction: 1.0)
            // 이미지 렌더링 컨텍스트 종료
            newImage.unlockFocus()
            
            processedImage = newImage
        }
        
        // 2. PNG 포맷으로 변환 (항상 PNG)
        // NSImage를 NSBitmapImageRep로 변환해야 이미지 데이터 표현에 접근할 수 있습니다.
        guard let tiffData = processedImage.tiffRepresentation else { return nil }
        guard let bitmapRep = NSBitmapImageRep(data: tiffData) else { return nil }
        
        // PNG 데이터 생성 (투명도 유지, 무손실)
        return bitmapRep.representation(using: .png, properties: [:])
    }
}
