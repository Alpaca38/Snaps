//
//  LikeRepository.swift
//  Snaps
//
//  Created by 조규연 on 7/24/24.
//

import Foundation
import RealmSwift

final class LikeRepository {
    private let realm: Realm
    
    init() throws {
        do {
            self.realm = try Realm()
        } catch {
            throw error
        }
    }
    
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
    
    func fetchFilter(searchText: String) -> [LikeItems] {
        let results = realm.objects(LikeItems.self).where { $0.photoGrapherName.contains(searchText, options: .caseInsensitive) }
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
    
    func deleteAll() {
        let photos = realm.objects(LikeItems.self)
        photos.forEach { 
            FileUtility.shared.removeImageFromDocument(filename: $0.id)
            FileUtility.shared.removeImageFromDocument(filename: $0.photoGrapherID)
        }
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("DeleteAll Error")
        }
    }
    
    func printRealmURL() {
        print(realm.configuration.fileURL!)
    }
}
