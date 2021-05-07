//
//  ViewController.swift
//  StormViewer_Project1
//
//  Created by Vaishant Makan on 23/10/20.
//

import UIKit

class ViewController: UITableViewController {
    
    //var pictures = [String]()
    var pictures = [pictureStruct]()
    
    @IBOutlet var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Storm Viewer"
        
        // Loading Saved Data if nothing saved then uploading ourselves
        let defaults = UserDefaults.standard
        
        if let savedPictures = defaults.object(forKey: "pictures") {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([pictureStruct].self, from: savedPictures as! Data)
            } catch {
                print("Failed to load Pictures")
            }
            
        } else {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasPrefix("nssl") {
                    
                    //this is a picture to load!
    //                pictures.append(item)
    //                pictures.sort()
                    let pic = pictureStruct(name: item, tapped: 0)
                    pictures.append(pic)
                    pictures.sort { $0.name < $1.name }
                }
            }
        }
    }
    
    
    //Runs evertime the view is about be shown ... eg when u come back to the view after clicking a pic and then pressing the back button...
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //tells about the number of cells in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    //tells about how the cells are gonna look like...it will run as many times as the mum of runs returned from above method....
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        //to resize the font of cells in table view
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.1
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
        
        cell.textLabel?.text = pictures[indexPath.row].name
        cell.detailTextLabel?.text = "Tapped \(pictures[indexPath.row].tapped) times"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        pictures[indexPath.row].tapped += 1
        
        save()
        
        //try loading the "Detail" view Controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
    
            vc.selectedImage = pictures[indexPath.row].name
            
            //for changing the title in the detailViewController
            vc.imageNum = indexPath.row + 1
            vc.totalPhotos = pictures.count
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        
        var items: [Any] = ["This app is great you should try it!"]
        
        if let url = URL(string: "https://www.hackingwithswift.com") {
            items.append(url)
        }
        
        let vc = UIActivityViewController(activityItems: items, applicationActivities: [])
        
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
    }
    
    //MARK: - Saving Method
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save Data")
        }
    }
}

