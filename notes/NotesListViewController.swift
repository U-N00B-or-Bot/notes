//U-N00B-or-Bot

import UIKit
import CoreData


class NotesListViewController: UITableViewController {
  
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var noteList : [Note] = []
    private var start: [Start] = []
    private var firstLaunch: Bool!
    private var countLabel = UILabel()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDataStart()
        print(start.count)
        print (start.randomElement()?.isFirst ?? "ERROR")
        if start.count == 0 {
            getStart()}
        //fetchDataStart()
        
        print(start.count)
        print (start.randomElement()?.isFirst ?? "ERROR")
        
        
        firstLaunch = start.randomElement()?.isFirst
        
     
        
        if firstLaunch == true {
            
            saveInBtn("Первая заметка", "Здравствуйте, это первая пустая заметка")
          
            
            start.randomElement()?.isFirst = false
            print(start.count)
            print (start.randomElement()?.isFirst ?? "ERROR")
            save()
        }
      
        
        fetchData()

    
    }

 
    

    
    private func save() {
       //let note = Note(context: context)
      
    
       
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
    }
    
  

    
    private func fetchDataStart(){
        
        let fetchRequest = Start.fetchRequest()
        
        
        
        do {
            start = try context.fetch(fetchRequest)
        } catch {
            print("Failed", error)
        }
        
       
      
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
         1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         noteList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let note = noteList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = note.title
        cell.contentConfiguration = content

        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Новая заметка", message: nil, preferredStyle: .alert)
              let saveAction = UIAlertAction(title: "Сохранить", style: .default) { action in
                   
                
                  
                  guard let note = alertController.textFields?.first?.text, !note.isEmpty else { return }
                   
                  
                
                       
                  self.saveInBtn(note, "Пустая заметка")
                  self.fetchData()
                  
                  self.tableView.reloadData()
                       
                    
                    
                }
        saveAction.isEnabled = false
              //  alertController.addTextField { _ in}
        alertController.addTextField { field in
            
            
            
            field.placeholder = "Введите название заметки"
                       field.delegate = self
                       field.returnKeyType = .done
                       
                       self.countLabel.text = "0/24"
                       self.countLabel.font = UIFont.systemFont(ofSize: 10)
                       self.countLabel.textColor = .black
                       self.countLabel.textAlignment = .left
                       field.rightView = self.countLabel
                       field.rightViewMode = .always
                       field.rightViewRect(forBounds: CGRect(x: -10, y: 0, width: 30, height: 30))
            
            
            
            
            
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: field, queue: OperationQueue.main, using:
                {_ in
                   
                    let textCount = field.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    
                    saveAction.isEnabled = textIsNotEmpty
                
            })
        }
        
        
        
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
    
    private func getStart() {
        let vakue = Start(context: context)
        vakue.isFirst = true
        
        start.append(vakue)
        

    }
    
   

  

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              guard let VC = segue.destination as? NoteViewController else {return}
              guard let indexPath = tableView.indexPathForSelectedRow else {return}
    
        let text = noteList[indexPath.row].body
        VC.numberIndex = indexPath.row
        VC.info = text ?? "error"
        VC.name = noteList[indexPath.row].title ?? "error"
       
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





extension NotesListViewController: UITextFieldDelegate {
    func textField(_ field: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = field.text ?? ""
        guard let stringsRange = Range(range, in: currentText) else { return false }
        let maxLetters = 24
        let updatedText = currentText.replacingCharacters(in: stringsRange, with: string)
        if updatedText.count > maxLetters {
            UIView.animate(withDuration: 0.1, animations: {
                self.countLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.countLabel.transform = CGAffineTransform.identity
                })
            })
            return false
        } else {
            countLabel.text = "\(updatedText.count)/\(maxLetters)"
            return true
        }
    }
}




