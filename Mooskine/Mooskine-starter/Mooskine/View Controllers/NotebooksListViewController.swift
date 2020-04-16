//
//  NotebooksListViewController.swift
//  Mooskine
//
//  Created by Josh Svatek on 2017-05-31.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import CoreData

class NotebooksListViewController: UIViewController {
    /// A table view that displays a list of notebooks
    @IBOutlet weak var tableView: UITableView!
   
    var dataController:DataController!
    
    fileprivate func setupFetchResultController() {
        let fetchRequest: NSFetchRequest<Notebook> = Notebook.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let resultController = ListDataSource<Notebook,NotebookCell>(tableView: tableView, managedObjectContext: dataController.viewContext, fetchRequest: fetchRequest) { (data, cell) in
            (cell as! NotebookCell).nameLabel.text = data.name
            if let count = data.notes?.count {
                let pageString = count == 1 ? "page" : "pages"
                (cell as! NotebookCell).pageCountLabel.text = "\(count) \(pageString)"
            }
        }
        tableView.dataSource = resultController
        tableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "toolbar-cow"))
        navigationItem.rightBarButtonItem = editButtonItem
        
        setupFetchResultController()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchResultController()
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //fetchResultController = nil
    }

    // -------------------------------------------------------------------------
    // MARK: - Actions

    @IBAction func addTapped(sender: Any) {
        presentNewNotebookAlert()
    }

    // -------------------------------------------------------------------------
    // MARK: - Editing

    /// Display an alert prompting the user to name a new notebook. Calls
    /// `addNotebook(name:)`.
    func presentNewNotebookAlert() {
        let alert = UIAlertController(title: "New Notebook", message: "Enter a name for this notebook", preferredStyle: .alert)

        // Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let name = alert.textFields?.first?.text {
                self?.addNotebook(name: name)
            }
        }
        saveAction.isEnabled = false

        // Add a text field
        alert.addTextField { textField in
            textField.placeholder = "Name"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { notif in
                if let text = textField.text, !text.isEmpty {
                    saveAction.isEnabled = true
                } else {
                    saveAction.isEnabled = false
                }
            }
        }

        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }

    /// Adds a new notebook to the end of the `notebooks` array
    func addNotebook(name: String) {
        let notebook = Notebook(context: dataController.viewContext)
        notebook.name = name
        notebook.creationDate = Date()
        try? dataController.viewContext.save()
        
    }

    /// Deletes the notebook at the specified index path
    func deleteNotebook(at indexPath: IndexPath) {
//        let notebookToDelete = fetchResultController.object(at: indexPath)
//        dataController.viewContext.delete(notebookToDelete)
//        try? dataController.viewContext.save()
    }

    func updateEditButtonState() {
//        if let sections = fetchResultController.sections {
//            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
//        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteNotebook(at: indexPath)
        default: () // Unsupported
        }
    }

    
    // -------------------------------------------------------------------------
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If this is a NotesListViewController, we'll configure its `Notebook`
        if let vc = segue.destination as? NotesListViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
          //      vc.notebook = fetchResultController.object(at: indexPath)
                vc.dataController = dataController
            }
        }
    }
}
