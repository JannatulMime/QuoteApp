//
//  Quote_AppApp.swift
//  Quote App
//
//  Created by Habibur Rahman on 18/4/25.
//

import SwiftUI
import CoreData

@main
struct Quote_AppApp: App {


    
    var body: some Scene {
        WindowGroup {
            MainView()
               // .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.managedObjectContext, CoreDataManager.instance.context)
        }
    }
}
