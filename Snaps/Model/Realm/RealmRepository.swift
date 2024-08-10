//
//  RealmRepository.swift
//  Snaps
//
//  Created by 조규연 on 8/10/24.
//

import Foundation
import RealmSwift

final class RealmRepository<T: Object> {
    private let realm: Realm
    
    init() throws {
        do {
            self.realm = try Realm()
        } catch {
            throw error
        }
    }
    
    func createItem(data: T) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("CreateItem Error")
        }
    }
    
    func fetchAll() -> [T] {
        let results = realm.objects(T.self)
        return Array(results)
    }
    
    func fetchSort(keyPath: String, ascending: Bool) -> [T] {
        let results = realm.objects(T.self).sorted(byKeyPath: keyPath, ascending: ascending)
        return Array(results)
    }
    
    func fetchFilter(searchText: String) -> [T] where T: LikeItems {
        let results = realm.objects(T.self).where { $0.photoGrapherName.contains(searchText, options: .caseInsensitive) }
        return Array(results)
    }
    
    func fetchItemFromProduct(id: String) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: id)
    }
    
    func deleteItem(data: T) {
        if let deletedData = data as? LikeItems {
            FileUtility.shared.removeImageFromDocument(filename: deletedData.id)
            FileUtility.shared.removeImageFromDocument(filename: deletedData.photoGrapherID)
        }
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print("DeleteItem Error")
        }
    }
    
    func deleteAll() {
        let objects = realm.objects(T.self)
        objects.forEach { object in
            if let deletedObject = object as? LikeItems {
                FileUtility.shared.removeImageFromDocument(filename: deletedObject.id)
                FileUtility.shared.removeImageFromDocument(filename: deletedObject.photoGrapherID)
            }
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
