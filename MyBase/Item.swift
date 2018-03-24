//
//  Item.swift
//  MyBase
//
//  Created by Felipe Mota on 24/03/18.
//  Copyright © 2018 Daniel Macedo. All rights reserved.
//

import Foundation
import Firebase

struct Item {
    var title: String?
    var addedBy: String?
    var completed: Bool
    var ref: FIRDatabaseReference?
    
    func toAnyObject() -> Any {
        return ["title": title!, "addedBy": addedBy!, "completed": completed]
    }
}
