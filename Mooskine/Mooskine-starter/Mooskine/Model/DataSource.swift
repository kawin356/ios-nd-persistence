//
//  DataSource.swift
//  Mooskine
//
//  Created by Kittikawin Sontinarakul on 15/4/2563 BE.
//  Copyright © 2563 Udacity. All rights reserved.
//

import UIKit
import CoreData

class ListDataSource<ObjectType: NSManagedObject, CellType: UITableViewCell>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return Cell
    }
    

}

