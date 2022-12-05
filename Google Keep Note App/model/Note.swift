//
//  Note.swift
//  Setting TableView
//
//  Created by Admin on 30/11/22.
//

import Foundation

struct Note{
    var title:String?
    var note:String?
    var id:String
    
    init(title: String? , note: String? , id:String) {
        self.title = title
        self.note = note
        self.id = id
    }

}
