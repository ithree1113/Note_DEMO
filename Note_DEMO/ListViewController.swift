//
//  ListViewController.swift
//  Note_DEMO
//
//  Created by 鄭宇翔 on 2016/11/18.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NoteViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
//    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var notes: [Note] = []
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        for index in 0...2 {
            let note = Note()
            note.text = "Note \(index)"
            notes.append(note)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        print("\(NSHomeDirectory())")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: true)
    }
    
    @IBAction func addNote(_ sender: UIBarButtonItem) {
        let note = Note()
        note.text = "New Note"
        
        self.notes.insert(note, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        
        cell.textLabel?.text = notes[indexPath.row].text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "noteSegue") {
            let noteViewController = segue.destination as! NoteViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                noteViewController.note = notes[indexPath.row]
                noteViewController.delagate = self
            }
            
        }
    }
    //MARK:- NoteViewControllerDelegate
    func didFinishUpdate(note: Note) {
        if let index = self.notes.index(of: note) {
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
    }
    

}
