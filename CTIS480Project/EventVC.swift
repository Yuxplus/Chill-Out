//
//  EventVC.swift
//  CTIS480Project
//
//  Created by Mert Ekin & Yusuf Özcan on 18.05.2024.
//
import UIKit
import CoreData

class EventVC: UIViewController {

    @IBOutlet weak var festLogo: UIImageView!
    @IBOutlet weak var festCard: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var events: [EventsData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundColor = UIColor(red: 0/255.0, green: 33/255.0, blue: 77/255.0, alpha: 1.0)
        self.view.backgroundColor = backgroundColor
        
        logo.image = UIImage(named: "3")
        festLogo.image = UIImage(named: "fest")
        
        // Configure collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Fetch events from Core Data
        fetchEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch events from Core Data
        fetchEvents()
    }
    
    func fetchEvents() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<EventsData> = EventsData.fetchRequest()
        
        do {
            events = try context.fetch(fetchRequest)
            collectionView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension EventVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of items: \(events.count)")
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventCollectionViewCell
        
        let event = events[indexPath.item]
        print("Configuring cell for item at index: \(indexPath.item), event title: \(event.title ?? "No Title")")
        cell.configure(with: event)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width - 20, height: 150)
        print("Size for item at index \(indexPath.item): \(size)")
        return size
    }
    
    // Ensure proper spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // Handle cell selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = events[indexPath.item]
        showAlertForEvent(event)
    }
    
    func showAlertForEvent(_ event: EventsData) {
        let title = event.title ?? "No Title"
        let location = event.location ?? "No Location"
        let time = event.time?.description ?? "No Time"
        let type = event.type ?? "No Type"
        
        let alert = UIAlertController(title: title, message: "Location: \(location)\nTime: \(time)\nType: \(type)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
