//
//  Book.swift
//  Data Application
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import Foundation

class Book{

    var title : String
    var author : String
    var page : Int
    var year  : String
    
    internal init(title: String, author: String, page: Int, year: String) {
           self.title = title
           self.author = author
           self.page = page
           self.year = year
       }
    
}
