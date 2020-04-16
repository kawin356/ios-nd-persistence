//
//  ListDataSource.swift
//  Mooskine
//
//  Created by Kittikawin Sontinarakul on 15/4/2563 BE.
//  Copyright © 2563 Udacity. All rights reserved.
//

import UIKit
import CoreData

class ListDataSource<ObjectType: NSManagedObject, CellType: UITableViewCell>: NSObject, NSFetchedResultsControllerDelegate, UITableViewDataSource {
    
    let tableView: UITableView
            
    var fetchResultController:NSFetchedResultsController<ObjectType>!

    var configure: ( ObjectType, UITableViewCell) -> Void

    var managedObjectContext: NSManagedObjectContext

    init(tableView: UITableView, managedObjectContext: NSManagedObjectContext, fetchRequest: NSFetchRequest<ObjectType>, configure: @escaping (ObjectType, Any) -> Void) {
        self.tableView = tableView
        self.configure = configure
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.managedObjectContext = managedObjectContext
        super.init()
        fetchResultController.delegate = self
        try? fetchResultController.performFetch()
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = fetchResultController.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NotebookCell.defaultReuseIdentifier, for: indexPath) as! NotebookCell
        configure(aCell, cell)
        return cell
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError("Error")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
        case .update,.move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        @unknown default:
            fatalError("Error")
        }
    }
}

