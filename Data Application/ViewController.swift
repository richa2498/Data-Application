//
//  ViewController.swift
//  Data Application
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var textFields: [UITextField]!
    var books : [Book]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(saveFile), name: UIApplication.willResignActiveNotification, object: nil)
    }

    
    func getFieldpath() ->String{
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if documentPath.count > 0 {
            let documentDirectory = documentPath[0]
            let filePath = documentDirectory.appending("/data.txt")
            return filePath
        }
        return ""
    }

    func loadData() {
        
        let filePath = getFieldpath()
        books = [Book]()
        if FileManager.default.fileExists(atPath: filePath){
            do{
                //Extract Data
                let fileContent = try  String(contentsOfFile: filePath )
                let contentArray = fileContent.components(separatedBy: "\n")
                for content in contentArray{
                    let bookContent = content.components(separatedBy: ",")
                    if bookContent.count == 4{
                        let book = Book(title: bookContent[0], author: bookContent[1], page: Int(bookContent[2])!, year: bookContent[3])
                        books?.append(book)
                    }
                }
            }catch{
                print(error)
            }
        }
    
    }
    
    @objc func saveFile()  {
        let filePath = getFieldpath()
        var saveString = ""
        for book in books!{
            saveString = "\(saveString)\(book.title),\(book.author),\(book.page),\(book.year)\n"
            
        }
        
        do{
            try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
        }catch{
            print(error)
        }
    }
    
    
    @IBAction func addBook(_ sender: Any) {
        let title = textFields[0].text ?? ""
        let author = textFields[1].text ?? ""
        let pages = Int(textFields[2].text ?? "0") ?? 0
        let year = textFields[3].text ?? ""
        
        let book = Book(title: title, author: author, page: pages, year: year)
        books?.append(book)
        
        for textfield in textFields{
            
           // textField.text  = title
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let BookTable = segue.destination as? BookTableVC{
            BookTable.books = self.books
        }
    }
    
    func saveCoreData()  {
        
        let appDelegete =  UIApplication.shared.delegate as! AppDelegate
        
        let manageContex = appDelegete.persistentContainer.viewContext
        
        
        for book in books! {
            let bookEntity = NSEntityDescription.insertNewObject(forEntityName: "BookDetail", into: manageContex)
            
            bookEntity.setValue(book.title, forKey: "title")
              bookEntity.setValue(book.year, forKey: "year")
              bookEntity.setValue(book.page, forKey: "pages")
              bookEntity.setValue(book.author, forKey: "author")
            
            do{
                try manageContex.save()
            }catch{
                print(error)
            }
          
        }
    }
    
    func loadCoreData(){
        
        books = [Book]()
        let appDelegete =  UIApplication.shared.delegate as! AppDelegate
              
        let manageContex = appDelegete.persistentContainer.viewContext
    }
    
    
}

 
