//
//  OrganizerVC.swift
//  CTIS480Project
//
//  Created by Mert Ekin & Yusuf Özcan on 18.05.2024.
//
import UIKit
import CoreData
import AudioToolbox

class OrganizerVC: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var events: [EventsData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // RGB değerlerini kullanarak UIColor oluştur
        let backgroundColor = UIColor(red: 0/255.0, green: 33/255.0, blue: 77/255.0, alpha: 1.0)
        
        // View'in arka plan rengini ayarla
        self.view.backgroundColor = backgroundColor

        // UIButton yazı rengini beyaz yap
        addButton.setTitleColor(UIColor.white, for: .normal)
        
        // UITableView çizgilerini beyaz yap
        tableView.separatorColor = UIColor.white
        
        // UITableView arka planını temizle
        tableView.backgroundColor = .clear
        
        // UITableView için delegate ve dataSource ayarla
        tableView.delegate = self
        tableView.dataSource = self
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
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension OrganizerVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let event = events[indexPath.row]
        
        // Hücre arka plan rengini temizle
        cell.backgroundColor = .clear
        
        // Hücre metin rengini beyaz yap
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = event.title ?? "No Title"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        let title = event.title ?? "No Title"
        let type = event.type ?? "No Type"
        let location = event.location ?? "No Location"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let time = dateFormatter.string(from: event.time ?? Date())
        
        let message = """
        Title: \(title)
        Type: \(type)
        Location: \(location)
        Time: \(time)
        """
        
        let alert = UIAlertController(title: "Event Details", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Sağ kaydırma işlemleri
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            // Show confirmation alert
            let alert = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete this event?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completionHandler(false)
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                // Perform delete operation
                self.deleteEvent(at: indexPath)
                self.playSystemSound(soundID: 1001)
                completionHandler(true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        deleteAction.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func playSystemSound(soundID: SystemSoundID) {
            AudioServicesPlaySystemSound(soundID)
        }
    // Sol kaydırma işlemleri
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let updateAction = UIContextualAction(style: .normal, title: "Update") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            // Perform update operation
            self.performSegue(withIdentifier: "updateEventSegue", sender: indexPath)
            self.playSystemSound(soundID: 1000)
            completionHandler(true)
        }
        updateAction.backgroundColor = .blue

        return UISwipeActionsConfiguration(actions: [updateAction])
    }
    
    // Method to delete event
    func deleteEvent(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let eventToDelete = events[indexPath.row]
        context.delete(eventToDelete)
        
        do {
            try context.save()
            events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
            // Optionally, show an error alert to the user
            let alert = UIAlertController(title: "Error", message: "Failed to delete the event.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Prepare for segue to UpdateEventVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateEventSegue",
           let destinationVC = segue.destination as? UpdateEventVC,
           let indexPath = sender as? IndexPath {
            destinationVC.event = events[indexPath.row]
        }
    }
    
    
}
