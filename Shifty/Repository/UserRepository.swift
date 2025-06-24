//
//  UserRepository.swift
//  QuickSniper
//
//  Created by 이민호 on 6/12/25.
//

import Foundation
import SwiftData

protocol UserRepository {
    func save(_ user: User) throws
    func update(_ user: User) throws
    func deleteAllUser() throws
}

final class DefaultUserRepository: UserRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func save(_ user: User) throws {
        let descriptor = FetchDescriptor<User>()
        let existingUsers = try context.fetch(descriptor)
                
        if !existingUsers.isEmpty {
            print("⚠️ User가 이미 존재합니다. 저장하지 않습니다.")
            return
        }
                
        context.insert(user)
        try context.save()
        print("✅ User 저장 완료")
    }
    
    func update(_ user: User) throws {
        try context.save()
    }
    
    func deleteAllUser() throws {
        try context.delete(model: User.self)
        try context.save()
        
        print("✅ 모든 User 삭제 완료 (효율적인 방법)")
    }
}
