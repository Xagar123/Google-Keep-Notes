//
//  ReminderAddController.swift
//  Google Keep Note App
//
//  Created by Admin on 16/12/22.
//

import UIKit

class ReminderAddController: UIViewController {
    
    let titleField: UITextField = UITextField(frame: CGRect(x: 10, y: 100, width: 400, height: 60))
    let descriptionField: UITextField = UITextField(frame: CGRect(x: 10, y: 180, width: 400, height: 60))

    let datePicker: UIDatePicker = UIDatePicker()
    
    public var complition: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        view.backgroundColor = .white
        displayTitleField()
        displayDatePicker()
        displayDescriptionField()
    }
    
    func configureNavBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSaveButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancleButton))
    }
    
    
    @objc func didTapSaveButton(){
        if let titleField = titleField.text, !titleField.isEmpty,
           let descText = descriptionField.text, !descText.isEmpty {
           let targetDate = datePicker.date
           complition?(titleField,descText,targetDate)
            
        }
    }
    
    @objc func cancleButton(){
        dismiss(animated: true, completion: nil)
    }
    
   func displayTitleField(){
       titleField.placeholder = "Enter Title"
       titleField.borderStyle = UITextField.BorderStyle.line
       titleField.backgroundColor = UIColor.white
       titleField.textColor = UIColor.blue
       
       self.view.addSubview(titleField)
    }
    func displayDescriptionField(){
        descriptionField.placeholder = "Enter description"
        descriptionField.borderStyle = UITextField.BorderStyle.line
        descriptionField.backgroundColor = UIColor.white
        descriptionField.textColor = UIColor.blue
        
        self.view.addSubview(descriptionField)
     }

    func displayDatePicker(){
        datePicker.frame = CGRect(x: 10, y: 260, width: self.view.frame.width, height: 100)
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        self.view.addSubview(datePicker)
    }
}
