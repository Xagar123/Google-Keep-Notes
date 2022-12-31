//
//  HomeController.swift
//  Side Menu Bar prog
//
//  Created by Admin on 25/11/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeController: UIViewController, UISearchBarDelegate{
    
    
    
    //MARK: - Properties
    
    var delegate:HomeControllerDelegate!
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let searchBar = UISearchBar()
    var isInSearchMode:Bool?
    var isSearching = false
    
    var addButton: UIBarButtonItem!
    var isListView = false
    var toggleButton = UIBarButtonItem()
    var searchBarNav = UIBarButtonItem()
    
    let db = Firestore.firestore()
    var noteArray = [Note]()
    lazy var filteredNotes = [Note]()
    
    var updatedCount = 10
    var lastDocument: QueryDocumentSnapshot?
    
    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        //corner radius
        // button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemBlue
        
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize:32 , weight: .medium ))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        
        //adding shadow
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.8
        return button
    }()
    
 //   let searchBarNav = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearchBar))
    let circle = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: nil)
    
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
        configureSearchBar()
        loadingInitialData()
        
        view.addSubview(floatingButton)
        //creating acton of button
        floatingButton.addTarget(self, action: #selector(didAddButton), for: .touchUpInside)
       // toggleButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid"), style: .done, target: self, action: #selector(butonTapped(sender:)))
        toggleButton = UIBarButtonItem(title: "List", style: .plain, target: self, action: #selector(butonTapped(sender:)))
        searchBarNav = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearchBar))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .systemBackground
        floatingButton.frame = CGRect(x: view.frame.size.width-70, y: view.frame.size.height-100, width: 60, height: 60)
        
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
    
    @objc func didAddButton(){
        let container = NoteViewController()
        let newVC = UINavigationController(rootViewController: container)
        present(newVC, animated: true)
    }
    
    func loadingInitialData(){
        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else {return}
        let initialQuary = self.db.collection("USER").document(uid).collection("Notes")
            .order(by: "noteTitle")
            .limit(to: 10)
        initialQuary.getDocuments { quarySnapshot, error in
            guard let snapshot = quarySnapshot else {
                print("Error retreving cities: \(error.debugDescription)")
                return
            }
            var listNote = [Note]()
            self.lastDocument = snapshot.documents.last
            snapshot.documents.forEach { document in
                let noteObject = document.data()
                let first = noteObject["noteTitle"] as? String ?? ""
                let second = noteObject["noteDescription"] as? String ?? ""
                let id = noteObject["id"] as? String ?? ""
                let date = noteObject["date"] as? Date
                let note = Note(title: first , note: second, id: id, date: date!)
                self.noteArray.append(note)
                //listNote.append(note)
            }
            //  self.noteArray = listNote
            self.collectionView.reloadData()
        }
        
    }
    
    
    
    func getingMoreData(){
        guard let lastDocument = lastDocument else {return}
        let moreQuary = db.collection("USER")
            .order(by: "noteTitle").start(afterDocument: lastDocument)
            .limit(to: 10)
        moreQuary.getDocuments { quarySnapshot, error in
            guard let snapshot = quarySnapshot else {
                print("Error retreving cities: \(error.debugDescription)")
                return
            }
            var listNote = [Note]()
            self.lastDocument = snapshot.documents.last
            snapshot.documents.forEach { document in
                let noteObject = document.data()
                let first = noteObject["noteTitle"] as? String ?? ""
                let second = noteObject["noteDescription"] as? String ?? ""
                let id = noteObject["id"] as? String ?? ""
                let date = noteObject["date"] as? Date
                let note = Note(title: first , note: second, id: id, date: date!)
                //self.noteArray.append(note)
                listNote.append(note)
                self.updatedCount = self.updatedCount + 1
                print("updating notes \(self.updatedCount)")
            }
            self.noteArray.append(contentsOf: listNote)
            self.collectionView.reloadData()
            print("")
        }
    }
    
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
            navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "List", style: .plain, target: self, action: #selector(butonTapped(sender:))),UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearchBar))]
        }else{
            navigationItem.rightBarButtonItems = nil
        }
    }
    
    @objc func butonTapped(sender: UIBarButtonItem){
        if isListView {
                toggleButton = UIBarButtonItem(title: "List", style: .plain, target: self, action: #selector(butonTapped(sender:)))
                isListView = false
            }else {
            toggleButton = UIBarButtonItem(title: "Grid", style: .plain, target: self, action: #selector(butonTapped(sender:)))
                isListView = true
            }
       // self.navigationItem.setRightBarButton(toggleButton, animated: true)
        self.navigationItem.setRightBarButtonItems([toggleButton,searchBarNav], animated: true)
        self.collectionView.reloadData()
        
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
            filteredNotes = noteArray.filter({ $0.title!.lowercased().contains(searchText.lowercased())
           })
            
            
        }
        self.collectionView.reloadData()
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
                    let date = noteObject["date"] as? Date
                    let newList = Note(title: first , note: second, id: id, date: date!)
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
                    let date = noteObject["date"] as? Date
                    let newList = Note(title: first , note: second, id: id, date: date!)
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
        if isSearching {
            return filteredNotes.count
        }else{
            return noteArray.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        if isSearching {
            cell.namelbl.text = filteredNotes[indexPath.row].title as? String
            cell.agelbl.text = filteredNotes[indexPath.row].note as? String
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.blue.cgColor
        }else{
            cell.namelbl.text = noteArray[indexPath.row].title as? String
            cell.agelbl.text = noteArray[indexPath.row].note as? String
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.blue.cgColor
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        if isListView {
//            return CGSize(width: (collectionView.frame.size.width / 2) - 3,
//                          height: (collectionView.frame.size.width / 2) - 3)
//        }
//        else{
//            return CGSize(width: (collectionView.frame.size.width / 1) - 3,
//                          height: (collectionView.frame.size.width / 3) - 3)
//        }
        let width = view.frame.width
            if isListView {
                return CGSize(width: width, height: 120)
            }else {
                return CGSize(width: (width - 15)/2, height: (width - 15)/2)
            }

        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == noteArray.count-1{
            
           getingMoreData()
        }
    }
}


