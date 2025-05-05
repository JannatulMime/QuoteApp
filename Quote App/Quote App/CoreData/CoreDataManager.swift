//
//  CoreDataManager.swift
//  Quote App
//
//  Created by Habibur Rahman on 21/4/25.
//

import Foundation
import CoreData

class CoreDataManager {
  
    var quoteList: [Quote] = []
    
    static let instance = CoreDataManager()
    let container : NSPersistentContainer
    let context : NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: Constants.CORE_DATA.dataContainer)
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error Loading Core Data - \(error)")
            }
        }
        context = container.viewContext
  
        whereIsMySQLite()
    }
    
    
    private func whereIsMySQLite() {
        let path = NSPersistentContainer
            .defaultDirectoryURL()
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding

        debugPrint("D>> \(String(describing: path))")
    }
    

//    func saveQuotesToCoreData(_ quotes: [Quote]) -> Bool {
//        for quote in quotes {
//            let entity = QuoteEntity(context: context)
//            entity.id = Int64(quote.id ?? 0)
//            entity.quote = quote.quote
//            entity.author = quote.author
//        }
//
//        do {
//            try context.save()
//            print("Quotes saved to Core Data.")
//            return true
//        } catch {
//            print("Failed to save: \(error)")
//            return false
//        }
//    }
    
    func saveQuotesToCoreData(_ quotes: [Quote]) -> Bool {
        for quote in quotes {
            // Check if quote already exists (by ID or content)
            let fetchRequest: NSFetchRequest<QuoteEntity> = QuoteEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", quote.id ?? 0)

            do {
                let existing = try context.fetch(fetchRequest)
                if existing.isEmpty {
                    // Only save if it doesn't already exist
                    let entity = QuoteEntity(context: context)
                    entity.id = Int64(quote.id ?? 0)
                    entity.quote = quote.quote
                    entity.author = quote.author
                } else {
                    print("Skipping duplicate quote with id: \(quote.id ?? -1)")
                }
            } catch {
                print("Failed to check for duplicates: \(error)")
            }
        }

        do {
            try context.save()
            print("New quotes saved to Core Data.")
            return true
        } catch {
            print("Failed to save: \(error)")
            return false
        }
    }

    
    func loadSavedQuotes() -> [Quote] {
        let request = QuoteEntity.fetchRequest()
        do {
            let savedEntities = try context.fetch(request)
            
            return savedEntities.map {
                Quote(id: Int($0.id), quote: $0.quote ?? "", author: $0.author ?? "")
            }
        } catch {
            print("Error loading saved quotes: \(error)")
            return []
        }
    }

}
