//U-N00B-or-Bot

import UIKit

class NoteViewController: UIViewController{
    private var noteList : [Note] = []
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var info = ""
    var name = ""
    var numberIndex: Int!
    private var countLabel = UILabel()
    
    @IBOutlet weak var sliderSize: UISlider!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var noteNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        textView.text = info
        
        noteNameTextField.text = name
        sliderSize.value = noteList[numberIndex].textSize
        textView.font = UIFont(name: "Arial", size: CGFloat(sliderSize.value))
        
        
        
        
        
        
        noteNameTextField.placeholder = "Введите название заметки"
        noteNameTextField.delegate = self
                    noteNameTextField.returnKeyType = .done
                   
                   self.countLabel.text = "0/24"
                   self.countLabel.font = UIFont.systemFont(ofSize: 10)
                   self.countLabel.textColor = .black
                   self.countLabel.textAlignment = .left
        noteNameTextField.rightView = self.countLabel
        noteNameTextField.rightViewMode = .always
        noteNameTextField.rightViewRect(forBounds: CGRect(x: -10, y: 0, width: 30, height: 30))
        
        
        
        
        
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object:  noteNameTextField, queue: OperationQueue.main, using:
            {_ in
               
            let textCount =  self.noteNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
           
            
            if textCount == 0 || textCount > 24 {
                self.saveBtn.isEnabled = false
            } else {
                self.saveBtn.isEnabled = true
            }

            
            
           
            
            
        })
        
        
        
        
        
        
        

        
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



extension NoteViewController: UITextFieldDelegate {
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

