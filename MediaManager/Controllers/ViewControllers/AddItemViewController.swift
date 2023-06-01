//
//  AddItemViewController.swift
//  MediaManager
//
//  Created by Colby Mehmen on 6/1/23.
//

import UIKit

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var tvShowCheckboxButton: UIButton!
    @IBOutlet weak var movieCheckBoxButton: UIButton!
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var yearPicker: UIPickerView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    
    @IBOutlet weak var isFavoriteSegmentedControl: UISegmentedControl!
    @IBOutlet weak var watchedSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: Properties
    var yearPickerValue = Calendar.current.component(.year, from: Date())
    var isMovie = true
    var ratingValue = 0.0
    var isFavorite = true
    var wasWatched = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        self.tvShowCheckboxButton.imageView?.image = UIImage(systemName: "square")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSaveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text,
           let mediaType = isMovie ? "Movie" : "TV Show",
           let itemDescription = descriptionTextView.text else { return }

        MediaItemController.shared.createMediaItem(
            title: title,
            mediaType: mediaType,
            year: yearPickerValue,
            itemDescription: itemDescription,
            rating: ratingValue,
            wasWatched: wasWatched,
            isFavorite: isFavorite
        )

        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onMovieCheckMarkTapped(_ sender: Any) {
        isMovie = true
        switchMovieTVButton()
    }
    
    @IBAction func onTvCheckMarkTapped(_ sender: Any) {
        isMovie = false
        switchMovieTVButton()
    }
    
    @IBAction func onRatingSliderChange(_ sender: Any) {
        let value = Double(ratingSlider.value)
        ratingLabel.text = "Rating: \(value.roundTo(places: 1))"
    }
    
    @IBAction func isFavoriteSegmentedControlChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
           isFavorite = true
        } else {
           isFavorite = false
        }
    }
    
    @IBAction func watchedSegmentedControlChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
           wasWatched = true
        } else {
           wasWatched = false
        }
    }
    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func switchMovieTVButton() {
        self.movieCheckBoxButton.imageView?.image = UIImage(systemName: isMovie ? "checkmark.square" : "square")
        self.tvShowCheckboxButton.imageView?.image = UIImage(systemName: isMovie ? "square" : "checkmark.square")
    }

}

extension AddItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let minYear = 1799
        let currentYear = Calendar.current.component(.year, from: Date())
        return currentYear - minYear
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       let year = Calendar.current.component(.year, from: Date()) - row
       return String(year)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       yearPickerValue = Calendar.current.component(.year, from: Date()) - row
    }
}

extension Double {
   func roundTo(places:Int) -> Double {
      let divisor = pow(10.0, Double(places))
      return (self * divisor).rounded() / divisor
   }
}
