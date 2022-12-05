//
//  MenuOption.swift
//  Side Menu Bar prog
//
//  Created by Admin on 26/11/22.
//
import UIKit

enum MenuOption: Int, CustomStringConvertible {
    
    case Notes
    case Reminders
    case CreateNewlable
    case Archive
    case Trash
    case Setting
    case HelpAndfeedback
    
    var description: String{
        switch self{
            
        case .Notes: return "Notes"
        case .Reminders: return "Reminders"
        case .CreateNewlable: return "Create New lable"
        case .Archive: return "Archive"
        case .Trash: return "Trash"
        case .Setting: return "Setting"
        case .HelpAndfeedback: return "Help & feedback"
        }
    }
    var image: UIImage{
        
        switch self{
        case .Notes: return UIImage(named: "home") ?? UIImage()
        case .Reminders: return UIImage(named: "Language") ?? UIImage()
        case .CreateNewlable: return UIImage(named: "download") ?? UIImage()
        case .Archive: return UIImage(named: "setting") ?? UIImage()
        case .Trash: return UIImage(named: "setting") ?? UIImage()
        case .Setting: return UIImage(named: "setting") ?? UIImage()
        case .HelpAndfeedback: return UIImage(named: "setting") ?? UIImage()
        }
    }
}
