//U-N00B-or-Bot

import UIKit
import CoreData





class NotesListViewController: UITableViewController {
  
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var noteList : [Note] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        fetchData()

    
    }

    private func fetchData(){
        let fetchRequest = Note.fetchRequest()
        
        do {
            noteList = try context.fetch(fetchRequest)
        } catch {
            print("Failed", error)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return noteList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let note = noteList[indexPath.row]
       // let note = Single.shared.notes[indexPath.row]
              
              var content = cell.defaultContentConfiguration()
        content.text = note.title
      
              
              cell.contentConfiguration = content

      

        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Новая заметка", message: "Введите название:", preferredStyle: .alert)
              let saveAction = UIAlertAction(title: "Сохранить", style: .default) { action in
                   // let tf = alertController.textFields?.first
                
                  
                  guard let note = alertController.textFields?.first?.text, !note.isEmpty else {return}
                   
                       
                
                       
                  self.saveInBtn(note, "Пустая заметка")
                  self.fetchData()
                  
                  self.tableView.reloadData()
                       
                    
                    
                }
       
                alertController.addTextField { _ in}
                let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in}
                
                alertController.addAction(saveAction)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
    }
    
    private func saveInBtn(_ noteName: String, _ noteBody: String) {
        let note = Note(context: context)
        note.title = noteName
        note.body = noteBody
        noteList.append(note)
        
        let cellIndex = IndexPath(row: noteList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
   

  

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              guard let VC = segue.destination as? NoteViewController else {return}
              guard let indexPath = tableView.indexPathForSelectedRow else {return}
    
        
       // notes[indexPath.row].body = textovoePole
        let text = noteList[indexPath.row].body
        
        print(indexPath.row)
        
       
        VC.numberIndex = indexPath.row
        VC.info = text ?? "error"
       
          }
    
    
 

    
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               let context = appDelegate.persistentContainer.viewContext
               let not = noteList.remove(at: indexPath.row)
               
               context.delete(not)
               do {
                   try context.save()
                   
               } catch let error as NSError{
                   print(error.localizedDescription)
               }
               
               
               self.tableView.reloadData()
               
               
               
           }
        }
    
}
