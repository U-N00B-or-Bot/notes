//U-N00B-or-Bot

import UIKit

class NoteViewController: UIViewController {
    private var noteList : [Note] = []
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var info = ""
    var numberIndex: Int!
    
    @IBOutlet weak var sliderSize: UISlider!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        textView.text = info
        sliderSize.value = noteList[numberIndex].textSize
        textView.font = UIFont(name: "Arial", size: CGFloat(sliderSize.value))
        

        // Do any additional setup after loading the view.
    }
    @IBAction func sliderAction(_ sender: Any) {
        textView.font = UIFont(name: "Arial", size: CGFloat(sliderSize.value))
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        
        noteList[numberIndex].body = textView.text
        noteList[numberIndex].textSize = sliderSize.value
        save()
        dismiss(animated: true, completion: nil)
    }
    
 
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
