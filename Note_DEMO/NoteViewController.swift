//
//  NoteViewController.swift
//  Note_DEMO
//
//  Created by 鄭宇翔 on 2016/11/18.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

import UIKit

protocol NoteViewControllerDelegate: class {
    func didFinishUpdate(note: Note)
}


class NoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var note: Note?
    weak var delagate: NoteViewControllerDelegate?
    var isNewImage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textView.text = self.note?.text
        self.imageView.image = self.note?.image()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        self.note?.text = self.textView.text
        
        if self.isNewImage {
            let uuid = NSUUID()
            let imageName = "\(uuid.uuidString).jpg"
            
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let imageURL = documentURL?.appendingPathComponent(imageName, isDirectory: false)
            print("\(imageURL)")
            let imageData = UIImageJPEGRepresentation(self.imageView.image!, 1)
            do {
                try imageData?.write(to: imageURL!)
                if let oldImageName = self.note?.imageName {
                    let oldImageURL = documentURL?.appendingPathComponent(oldImageName, isDirectory: false)
                    try FileManager.default.removeItem(at: oldImageURL!)
                }
                self.note?.imageName = imageName
            } catch  {
                print(error)
            }
        }
        
        self.delagate?.didFinishUpdate(note: self.note!)
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func camera(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .savedPhotosAlbum
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)

    }

    //MARK:- UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = image
        self.isNewImage = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}