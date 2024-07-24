//
//  LikeRepository.swift
//  Snaps
//
//  Created by 조규연 on 7/24/24.
//

import Foundation
import RealmSwift

final class LikeRepository {
    private let realm = try! Realm()
    
    func createItem(data: LikeItems) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("CreateItem Error")
        }
    }
    
    func fetchAll() -> [LikeItems] {
        let results = realm.objects(LikeItems.self)
        return Array(results)
    }
    
    func fetchSort(keyPath: String, ascending: Bool) -> [LikeItems] {
        let results = realm.objects(LikeItems.self).sorted(byKeyPath: keyPath, ascending: ascending) // default: latest
        return Array(results)
    }
    
    func fetchItemFromProduct(id: String) -> LikeItems? {
        return realm.objects(LikeItems.self).where {
            $0.id == id
        }.first
    }
    
    func deleteItem(data: LikeItems) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print("DeleteItem Error")
        }
    }
    
    func printRealmURL() {
        print(realm.configuration.fileURL!)
    }
}
