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
    private var notificationToken: NotificationToken?
    
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
    
    func observe(completion: @escaping (RealmCollectionChange<Results<LikeItems>>) -> Void) {
        let results = realm.objects(LikeItems.self)
        notificationToken = results.observe { changes in
            switch changes {
            case .initial:
                completion(.initial(results))
            case .update(_, _, _, _):
                completion(.update(results, deletions: [], insertions: [], modifications: []))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
