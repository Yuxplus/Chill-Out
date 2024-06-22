//
//  IntroVC.swift
//  CTIS480Project
//
//  Created by Mert Ekin & Yusuf Özcan on 18.05.2024.
//

import UIKit
import CoreData
import AudioToolbox

class IntroVC: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // RGB değerlerini kullanarak UIColor oluştur
        let backgroundColor = UIColor(red: 0/255.0, green: 33/255.0, blue: 77/255.0, alpha: 1.0)
        
        // View'in arka plan rengini ayarla
        self.view.backgroundColor = backgroundColor
        
        // ImageView'e image dosyasını ata
        imageView.image = UIImage(named: "3")
        
        setupButton()
        
        // Fetch data.json when the app is opened
        fetchDataIfNeeded()
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        // Play system sound
        AudioServicesPlaySystemSound(1009) // This plays the "Tock" sound

        // Segue'yi başlat
        self.performSegue(withIdentifier: "toUserVC", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserVC" {
            // Gerekirse burada veri aktarımı yapılabilir
        }
    }
   
    func setupButton() {
        // Button'un köşe yuvarlamasını ayarla
        startButton.layer.cornerRadius = 23
        startButton.layer.masksToBounds = true
    }
    
    func fetchDataIfNeeded() {
        // Check if data exists in the database
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<EventsData> = EventsData.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                // Data does not exist, fetch it from the local file
                fetchDataFromFile()
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func fetchDataFromFile() {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else { return }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            saveDataToDatabase(data: data)
        } catch {
            print("Error reading data from file: \(error)")
        }
    }
    
    func saveDataToDatabase(data: Data) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Parse the JSON data
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let jsonDict = json as? [String: Any], let events = jsonDict["events"] as? [[String: Any]] {
                for event in events {
                    let eventEntity = EventsData(context: context)
                    eventEntity.location = event["location"] as? String ?? ""
                    eventEntity.type = event["type"] as? String ?? ""
                    eventEntity.title = event["title"] as? String ?? ""
                    if let timeString = event["time"] as? String, let time = ISO8601DateFormatter().date(from: timeString) {
                        eventEntity.time = time
                    }
                }
                try context.save()
            }
        } catch {
            print("Error saving data to database: \(error)")
        }
    }
}
