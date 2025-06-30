//
//  FaviconManagerTests.swift
//  ShiftyTests
//
//  Created by 이민호 on 6/27/25.
//

import XCTest

final class FaviconManagerTests: XCTestCase {

    // MARK: - Properties
    var sut: FaviconManager! // System Under Test (테스트 대상)

    // MARK: - Setup & Teardown
    override func setUpWithError() throws {
        // 각 테스트 메서드가 실행되기 전에 호출됩니다.
        // 여기에서 테스트에 필요한 객체들을 초기화합니다.
        sut = FaviconManager()
    }

    override func tearDownWithError() throws {
        // 각 테스트 메서드가 실행된 후에 호출됩니다.
        // 여기에서 테스트에 사용된 자원들을 정리합니다.
        sut = nil
    }

    // MARK: - Test Cases

    /// 유효한 URL로 파비콘을 성공적으로 가져오는지 테스트
    func testFetchFavicon_withValidURL_shouldReturnData() throws {
        // Given (주어진 상황): 테스트할 유효한 URL
        // 실제 파비콘이 존재하는 웹사이트를 사용하는 것이 좋습니다.
        let testURL = URL(string: "https://www.apple.com")!
        
        // 비동기 작업의 완료를 기다리기 위한 XCTestExpectation 생성
        let expectation = XCTestExpectation(description: "Favicon data should be fetched successfully for a valid URL")

        // When (행동): FaviconManager의 fetchFavicon 메서드 호출
        sut.fetchFavicon(for: testURL) { data in
            // Then (예상 결과):
            // 1. 데이터가 nil이 아니어야 합니다.
            XCTAssertNotNil(data, "Favicon data should not be nil for a valid URL")
            // 2. 데이터가 비어있지 않아야 합니다. (실제 이미지 데이터가 있어야 함)
            XCTAssertFalse(data?.isEmpty ?? true, "Favicon data should not be empty")
            
            // 가져온 데이터가 이미지인지 확인하는 추가적인 테스트 (선택 사항)
            #if canImport(UIKit) // UIKit이 iOS/tvOS/watchOS에서만 사용 가능하므로 조건부 컴파일
            if let imageData = data, let image = UIImage(data: imageData) {
                XCTAssertNotNil(image, "Fetched data should be convertible to UIImage")
                XCTAssertGreaterThan(image.size.width, 0, "Image width should be greater than 0")
                XCTAssertGreaterThan(image.size.height, 0, "Image height should be greater than 0")
            } else {
                XCTFail("Could not convert fetched data to UIImage or data was nil")
            }
            #elseif canImport(AppKit) // AppKit이 macOS에서만 사용 가능하므로 조건부 컴파일
            if let imageData = data, let image = NSImage(data: imageData) {
                XCTAssertNotNil(image, "Fetched data should be convertible to NSImage")
                XCTAssertGreaterThan(image.size.width, 0, "Image width should be greater than 0")
                XCTAssertGreaterThan(image.size.height, 0, "Image height should be greater than 0")
            } else {
                XCTFail("Could not convert fetched data to NSImage or data was nil")
            }
            #endif

            // 비동기 작업이 완료되었음을 Expectation에 알립니다.
            expectation.fulfill()
        }

        // 모든 expectation이 충족될 때까지 기다립니다. (최대 10초)
        // 네트워크 요청이므로 충분한 시간을 줍니다.
        wait(for: [expectation], timeout: 10.0)
    }

    /// 호스트가 없는 URL (유효하지 않은 URL 형식)일 때 nil을 반환하는지 테스트
    func testFetchFavicon_withInvalidURLFormat_shouldReturnNil() throws {
        // Given
        // URL 객체는 생성되지만, host 속성이 nil이 되는 경우
        let testURL = URL(string: "invalid-url-string")!
        
        let expectation = XCTestExpectation(description: "Favicon data should be nil for an invalid URL format")

        // When
        sut.fetchFavicon(for: testURL) { data in
            // Then
            XCTAssertNil(data, "Favicon data should be nil for an invalid URL format")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    /// 존재하지 않는 도메인으로 파비콘을 요청했을 때 nil을 반환하는지 테스트
    func testFetchFavicon_withNonExistentDomain_shouldReturnNil() throws {
        // Given
        // 실제 인터넷에 존재하지 않는 도메인 (충돌 가능성이 낮은 무작위 도메인)
        let testURL = URL(string: "https://www.definitely-not-a-real-website-1a2b3c4d.com")!
        
        let expectation = XCTestExpectation(description: "Favicon data should be nil for a non-existent domain")

        // When
        sut.fetchFavicon(for: testURL) { data in
            // Then
            XCTAssertNil(data, "Favicon data should be nil for a non-existent domain")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0) // 네트워크 타임아웃을 고려하여 10초
    }
    
    /// 파비콘이 없는 웹사이트 (예: 일부 개인 블로그 등)일 때 nil을 반환하는지 테스트 (선택 사항)
    func testFetchFavicon_withWebsiteWithoutFavicon_shouldReturnNil() throws {
        // 이 테스트는 파비콘이 존재하지 않는 특정 웹사이트 URL을 알아야 합니다.
        // 예: "https://example.com" 은 파비콘이 없을 수 있습니다.
        // 테스트할 실제 URL로 교체하세요.
        let testURL = URL(string: "https://example.com")! // 또는 파비콘이 없는 다른 URL
        
        let expectation = XCTestExpectation(description: "Favicon data should be nil for a website without a favicon")

        sut.fetchFavicon(for: testURL) { data in
            XCTAssertNil(data, "Favicon data should be nil for a website without a favicon")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
