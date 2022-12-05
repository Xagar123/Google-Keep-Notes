//
//  UpdateViewController.swift
//  Social Login
//
//  Created by Admin on 04/12/22.
//

import UIKit
import FirebaseFirestore
import FirebaseCore

class UpdateViewController: UIViewController {
    
    let textField: UITextField = {
        let noteTitle = UITextField()
        noteTitle.placeholder = "Enter here"
        noteTitle.textAlignment = .left
        noteTitle.translatesAutoresizingMaskIntoConstraints = false
        return noteTitle
    }()
    
    let noteField: UITextField = {
        let note = UITextField()
        note.placeholder = "Enter here"
        note.textAlignment = .left
        note.backgroundColor = .white
        note.translatesAutoresizingMaskIntoConstraints = false
        return note
    }()
    
    lazy var notelbl:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.text = "hello world"
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var field1: String! = nil
    var field2: String! = nil
    var idField: DocumentReference? = nil
    
    public var completion: ((String) -> Void)?
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("note id \(idField)")
        view.addSubview(textField)
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        textField.becomeFirstResponder()
        
        view.addSubview(noteField)
        noteField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noteField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        noteField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        noteField.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        
        textField.text = field1
        noteField.text = field2
        
        
        
        view.backgroundColor = .white
       // self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveButton))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelButton))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(deleteItem))
        
    }
    
    
//    @objc func handleSaveButton(){
//
//        if let inputTitle = textField.text , let inputNote = noteField.text{
//
//         //   let newData = Note(title: inputTitle, note: inputNote)
//
//            var ref:DocumentReference? = nil
//
//            let documentRef = self.db.collection("USER").document()
//            let userData = [
//                "noteTitle": inputTitle,
//          "noteDescription": inputNote,
//                "id": documentRef.documentID
//            ]
//            ref = self.db.collection("USER").addDocument(data: userData){
//                (error:Error?) in
//                        if let error = error{
//                        print("\(error.localizedDescription)")
//                      }else{
//                    print("Document is created with id: \(ref?.documentID)")
//                          self.dismiss(animated: true, completion: nil)
//                 }
//              }
//           }
//        }
    
    
    @objc func handleCancelButton(){
        updateData()
        self.dismiss(animated: true,completion: nil)
    }

    @objc func deleteItem(){
        
//        do {
//            completion!(idField)
//            }
//        dismiss(animated: true,completion: nil)
    }

    func updateData(){
        
     //   var ref:DocumentReference? = idField
        
        if let titleField = textField.text, let descField = noteField.text {
        //    var ref:DocumentReference? = idField
            let userData = [
                            "noteTitle": titleField,
                     "noteDescription": descField,
                            "id": idField
            ] as [String : Any]
            
             db.collection("USER").document().updateData(userData)
                { (error) in
                    if error != nil{
                      print("Error")
                    }
                    else {
                      print("succesfully updated")
                    }
                  
            }
        }
    }


}
