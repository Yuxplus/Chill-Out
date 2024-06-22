//
//  UpdateEventVC.swift
//  CTIS480Project
//
//  Created by Mert Ekin & Yusuf Özcan on 19.05.2024.
//

import UIKit
import MapKit
class UpdateEventVC: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var timeDatePicker: UIDatePicker!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    var event: EventsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // RGB değerlerini kullanarak UIColor oluştur
        let backgroundColor = UIColor(red: 0/255.0, green: 33/255.0, blue: 77/255.0, alpha: 1.0)
        
        // View'in arka plan rengini ayarla
        self.view.backgroundColor = backgroundColor
        
        // Segment kontrolüne hedef ekle
        typeSegment.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
            
        typeSegment.selectedSegmentIndex = 0
        segmentChanged(typeSegment)

        searchCompleter.delegate = self
        locationTextField.addTarget(self, action: #selector(locationTextFieldChanged(_:)), for: .editingChanged)
        
        // Setup table view for search results
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        // Set the minimum date for the date picker to the start of tomorrow
        timeDatePicker.minimumDate = getStartOfTomorrow()
        
        // Load event data if available
        if let event = event {
            titleTextField.text = event.title
            locationTextField.text = event.location
            timeDatePicker.date = event.time ?? Date()
            switch event.type {
            case "Concert":
                typeSegment.selectedSegmentIndex = 0
            case "Standup":
                typeSegment.selectedSegmentIndex = 1
            case "Workshop":
                typeSegment.selectedSegmentIndex = 2
            default:
                typeSegment.selectedSegmentIndex = 0
            }
            segmentChanged(typeSegment)
        }
        
        // Add target for save button
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    @objc func locationTextFieldChanged(_ textField: UITextField) {
        if let query = textField.text, !query.isEmpty {
            searchCompleter.queryFragment = query
        } else {
            searchResults.removeAll()
            tableView.reloadData()
            tableView.isHidden = true
        }
    }
    
    func isDateValid() -> Bool {
        // Check if the selected date is valid (not today)
        let selectedDate = timeDatePicker.date
        let calendar = Calendar.current
        
        // Create the start of today
        let startOfToday = calendar.startOfDay(for: Date())
        
        // Create the start of tomorrow
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
        print(startOfToday)
        print(startOfTomorrow)
        print(selectedDate)
        print(selectedDate >= startOfTomorrow)
        // If the selected date is before the start of tomorrow, it's not valid
        return selectedDate >= startOfTomorrow
    }
    func showDateAlert() {
        let alert = UIAlertController(title: "Error", message: "Please select a date starting from tomorrow.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func getStartOfTomorrow() -> Date {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
        return startOfTomorrow
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        // Seçime göre imageView'i güncelle
        switch sender.selectedSegmentIndex {
        case 0:
            typeImage.image = UIImage(named: "concert.jpeg")
        case 1:
            typeImage.image = UIImage(named: "standup.jpeg")
        case 2:
            typeImage.image = UIImage(named: "workshop.jpeg")
        default:
            break
        }
    }
    
    @objc func saveButtonTapped() {
        // Validate input fields
        if areFieldsValid() {
            if isDateValid() {
                updateEvent()
            }else{
                showDateAlert()
            }
        } else {
            // One or more fields are empty, show an alert
            showAlert()
        }
    }
    
    func areFieldsValid() -> Bool {
        // Check if any of the text fields are empty
        guard let title = titleTextField.text, !title.isEmpty,
              let location = locationTextField.text, !location.isEmpty else {
            return false
        }
        return true
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "All fields are required.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func updateEvent() {
        // Get the data from the input fields
        guard let title = titleTextField.text,
              let location = locationTextField.text else {
            return
        }
        let date = timeDatePicker.date
        let typeIndex = typeSegment.selectedSegmentIndex
        
        // Convert typeIndex to string
        let type: String
        switch typeIndex {
        case 0:
            type = "Concert"
        case 1:
            type = "Standup"
        case 2:
            type = "Workshop"
        default:
            type = "Other"
        }
        
        // Update the event
        event?.title = title
        event?.location = location
        event?.time = date
        event?.type = type
        
        // Get the managed object context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        // Save the context
        do {
            try context.save()
            // Event updated successfully
            // Navigate back to OrganizerVC
            navigationController?.popViewController(animated: true)
        } catch {
            // Handle the error
            let alert = UIAlertController(title: "Error", message: "Failed to update the event.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
// MARK: - MKLocalSearchCompleterDelegate
extension UpdateEventVC: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
        tableView.isHidden = searchResults.isEmpty
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Location search failed with error: \(error)")
    }
}


extension UpdateEventVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        locationTextField.text = selectedResult.title
        tableView.isHidden = true
    }
}
