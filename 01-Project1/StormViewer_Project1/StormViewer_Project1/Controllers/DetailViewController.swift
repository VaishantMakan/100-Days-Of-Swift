//
//  DetailViewController.swift
//  StormViewer_Project1
//
//  Created by Vaishant Makan on 27/10/20.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    var imageNum: Int?
    var totalPhotos: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture \(imageNum!) of \(totalPhotos!)"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
        
    }
    
    @objc func shareTapped() {
        
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        
        
        //this line is very important if making for ipads as in iphones the share button will fill the entire screen so no worries but in ipads it acts as a pop up from side so not writing it can cause crash
        //explanation - On iPad the activity view controller will be displayed as a popover using the new UIPopoverPresentationController, it requires that you specify an anchor point for the presentation of the popover using one of the three following properties:
        
        //barButtonItem
        //sourceView
        //sourceRect
        //In order to specify the anchor point you will need to obtain a reference to the UIActivityController's UIPopoverPresentationController and set one of the properties as follows:
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
        
    }
}
