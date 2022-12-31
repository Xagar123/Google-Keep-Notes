//
//  NoteViewController.swift
//  Setting TableView
//
//  Created by Admin on 30/11/22.
//

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class NoteViewController: UIViewController {
    
    let textField: UITextField = {
        let noteTitle = UITextField()
        noteTitle.placeholder = "Title"
        noteTitle.textAlignment = .left
        noteTitle.translatesAutoresizingMaskIntoConstraints = false
        return noteTitle
    }()
    
    let noteField: UITextField = {
        let note = UITextField()
        note.placeholder = "Discription"
        note.textAlignment = .left
        note.backgroundColor = UIColor.white
        note.translatesAutoresizingMaskIntoConstraints = false
        return note
    }()
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("note view")
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
        
        
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveButton))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelButton))
        
    }
    
    
    @objc func handleSaveButton(){

        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else{return}
        if let inputTitle = textField.text , let inputNote = noteField.text{
            
         //   let newData = Note(title: inputTitle, note: inputNote)
            
            var ref:DocumentReference? = nil
            
            let documentRef = self.db.collection("USER").document()
            let userData:[String : Any] = [
                "noteTitle": inputTitle,
          "noteDescription": inputNote,
                "id": documentRef.documentID,
                "date": Timestamp(date: Date())
                
            ]
            ref = self.db.collection("USER").document(uid).collection("Notes").addDocument(data: userData){
                (error:Error?) in
                        if let error = error{
                        print("\(error.localizedDescription)")
                      }else{
                    print("Document is created with id: \(ref?.documentID)")
                          self.dismiss(animated: true, completion: nil)
                 }
              }
           }
        }
    
    
    @objc func handleCancelButton(){
        self.dismiss(animated: true,completion: nil)
    }


    

}
