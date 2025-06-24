//
//  UserUseCase.swift
//  QuickSniper
//
//  Created by 이민호 on 6/12/25.
//

import Foundation

protocol UserUseCase {
    func createUser(_ user: User) throws
    func updateUser(_ user: User) throws
    func deleteAllUser() throws
}

final class DefaultUserUserCase: UserUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func createUser(_ user: User) throws {
        do {
            try repository.save(user)
        } catch {
            print("[Error]: DefaultUserUserCase - craeteUser \(error)")
        }
    }
    
    func updateUser(_ user: User) throws {
        try repository.update(user)
    }
    
    func deleteAllUser() throws {
        do {
            try repository.deleteAllUser()
        } catch {
            print("[ERROR]: DefaultUserUserCase-deleteAllUser \(error)")
        }
    }
}
