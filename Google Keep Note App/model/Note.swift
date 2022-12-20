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
    var date: Date
    
    
    
    init(title: String? , note: String? , id:String,date:Date) {
        self.title = title
        self.note = note
        self.id = id
        self.date = date
        
    }

}
