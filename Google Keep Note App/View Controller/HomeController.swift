//
//  HomeController.swift
//  Side Menu Bar prog
//
//  Created by Admin on 25/11/22.
//

import UIKit
import FirebaseFirestore

class HomeController: UIViewController, UISearchBarDelegate{
    
    //MARK: - Properties
    
    var delegate:HomeControllerDelegate!
    var isInSearchMode:Bool?
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
//    let tableView: UITableView = {
//        let table = UITableView()
//        return table
//    }()
    let searchBar = UISearchBar()

    var isSearching = false
    var addButton: UIBarButtonItem!
    
    let db = Firestore.firestore()
    var noteArray = [Note]()
    lazy var filteredNotes = [Note]()
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .darkGray
        
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        filteredNotes = noteArray
        checkForUpdate()
        configureSearchBar()
       // loadData()
        print("\(noteArray.count)")
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddContact))
        
    }
       override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // configureUI()
        configureNavigationBar()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .white

    }
    
    //MARK: - Handler
    func configureNavigationBar(){
        print("navigation bar")
       navigationController?.navigationBar.barTintColor = .darkGray
       navigationController?.navigationBar.barStyle = .default
        navigationItem.title = "Keep Note"
        var menubtn = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(handleMenuToggle))
        self.navigationItem.leftBarButtonItem = menubtn
        menubtn.tintColor = UIColor.black
    }
    @objc func handleMenuToggle(){
        print("menu button clicked")
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
//    @objc func handleAddContact(){
//        let controller = NoteViewController()
//        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
//        print("item added")
//
//    }
    

   func configureSearchBar(){
       
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .black
        
        showSearchBarButton(shouldShow: true)
        
    }
    @objc func handleShowSearchBar(){

        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }

    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearchBar))
        }else{
            navigationItem.rightBarButtonItem = nil
        }
    }

    func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("did taped cancle")

       search(shouldShow: false)

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            isSearching = false
        }
        else{
            isSearching = true
            filteredNotes = noteArray.filter({$0.title?.lowercased().contains(searchBar.text!.lowercased())})
        }
        self.collectionView?.reloadData()
    }

    func loadData(){
        db.collection("USER").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let noteObject = document.data()
                    let first = noteObject["noteTitle"] as? String ?? ""
                    let second = noteObject["noteDescription"] as? String ?? ""
                    let id = noteObject["id"] as? String ?? ""
                    let newList = Note(title: first , note: second, id: id)
                    self.noteArray.append(newList)
                    
                    print("\(document.documentID) => \(document.data())")
                }
                self.collectionView.reloadData()
            }
        }

    }
    func checkForUpdate(){
        db.collection("USER").addSnapshotListener { [self] querySnapdhot, error in
            guard let snapshot = querySnapdhot else {return}
            snapshot.documentChanges.forEach { diff in
                
                //to do
                switch (diff.type){
                    
                case .added:
                    let noteObject = diff.document.data()
                    let first = noteObject["noteTitle"] as? String ?? ""
                    let second = noteObject["noteDescription"] as? String ?? ""
                    let id = noteObject["id"] as? String ?? ""
                    let newList = Note(title: first , note: second, id: id)
                    self.noteArray.append(newList)
                    self.collectionView.reloadData()
                    print("case")
                    
                case .modified:
                    
                    print("updated successfuly")
                    
                case .removed:
                    self.db.collection("USER").document("id").delete(){ err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                    self.collectionView.reloadData()
                    print("case")
                }
                
                if diff.type == .modified {
                    // self.noteArray.append(Note(title: "", note: "", id: "")) // what to append here
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
   

}

extension HomeController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
        cell.namelbl.text = noteArray[indexPath.row].title as? String
        cell.agelbl.text = noteArray[indexPath.row].note as? String
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.blue.cgColor
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 3) - 3,
                      height: (collectionView.frame.size.width / 3) - 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Selected index \(indexPath.section) and row: \(indexPath.row)")
        let container = UpdateViewController()
        container.field1 = noteArray[indexPath.row].title
        container.field2 = noteArray[indexPath.row].note
        container.idField = noteArray[indexPath.row].id
        present(UINavigationController(rootViewController: container), animated: true)
        
        container.completion = { noteid in
            self.db.collection("USER").document(container.idField).delete(){ err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    //self.checkForUpdate()
                    //self.loadData()
                    print("Document successfully removed!")
                    self.collectionView.reloadData()
                }
            }
           // self..reloadData()
            self.collectionView.reloadData()
            print("case")
        }
        
    }
}


