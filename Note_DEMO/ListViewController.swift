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
    
//    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let noteEntity = Contants.CoredataEntity.Note.Note
    var notes: [Note] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let coredataManager = CoreDataManager.sharedInstance
        // Sort: New->Old
        self.notes = coredataManager.load(self.noteEntity, byPredicate: nil, bySort: [Contants.CoredataEntity.Note.index: false], byLimit: nil) as! [Note]

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        print("\(MyNoteDirectory().myHomePath)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Set editing mode for sliding delete
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: true)
    }
    
    @IBAction func addNote(_ sender: UIBarButtonItem) {
        
        // An auto increasing counter to sort
        let userDefault = UserDefaults.standard
        var nowIndex = 1
        if let savedIndex = userDefault.object(forKey: Contants.NSDefaultKeys.noteIndex) as? Int {
            nowIndex = savedIndex + 1
        }
        
        let coredataManager = CoreDataManager.sharedInstance
        let note = coredataManager.insert(self.noteEntity, attributeInfo: [Contants.CoredataEntity.Note.text: "New Note", Contants.CoredataEntity.Note.index: "\(nowIndex)"]) as! Note
        self.notes.insert(note, at: 0)

        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        
        userDefault.set(nowIndex, forKey: Contants.NSDefaultKeys.noteIndex)
    }
    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Contants.CellIdentifiers.noteCell, for: indexPath)
        
        let note = notes[indexPath.row]
        
        cell.textLabel?.text = note.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let coredataManager = CoreDataManager.sharedInstance
            coredataManager.delete(selectedData: self.notes[indexPath.row])
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
        if (segue.identifier == Contants.Segues.listToNote) {
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
            let coredataManager = CoreDataManager.sharedInstance
            coredataManager.save()
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
    }
    

}
