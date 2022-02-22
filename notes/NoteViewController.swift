//U-N00B-or-Bot

import UIKit

class NoteViewController: UIViewController {
    private var noteList : [Note] = []
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var info = ""
    var numberIndex: Int!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        textView.text = info

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        
        noteList[numberIndex].body = textView.text
        save()
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func save() {
       //let note = Note(context: context)
        
    
       
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
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
}
