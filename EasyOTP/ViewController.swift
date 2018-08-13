//
//  ViewController.swift
//  EasyOTP
//
//  Created by Lucas Ortigoso on 13/08/18.
//  Copyright © 2018 Lucas Ortigoso. All rights reserved.
//

import Foundation
import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "NameCellID"
        static let SizeCell = "SizeCellID"
    }
    
    @IBOutlet var tableView: NSTableView?
    var data: NSArray?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = ["Oi","Oi2"]
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        
        var text: String = ""
        var cellIdentifier: String = ""
        
        // 1
        guard let item = data?[row] else {
            return nil
        }
        
        // 2
        if tableColumn == tableView.tableColumns[0] {
            print(item)
            text = item as! String
            cellIdentifier = CellIdentifiers.NameCell
        }
        
        // 3
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data?.count ?? 0
    }
}
