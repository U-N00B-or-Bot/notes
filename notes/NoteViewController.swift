//U-N00B-or-Bot

import UIKit

class NoteViewController: UIViewController {
    private var noteList : [Note] = []
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var info = ""
    var name = ""
    var numberIndex: Int!
    
    @IBOutlet weak var sliderSize: UISlider!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var noteNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        textView.text = info
        
        noteNameTextField.text = name
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
        noteList[numberIndex].title = noteNameTextField.text
        save()
        dismiss(animated: true, completion: nil)
    }
    
 
    private func save() {
      
      
    
       
        if context.hasChanges {
            do {
                try context.save()
            } catch {
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
