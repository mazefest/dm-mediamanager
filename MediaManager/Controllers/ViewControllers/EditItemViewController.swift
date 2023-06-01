//
//  EditItemViewController.swift
//  MediaManager
//
//  Created by Colby Mehmen on 6/1/23.
//

import UIKit

protocol EditDetailDelegate: AnyObject {
   func mediaItemEdited(title: String, rating: Double, year: Int, description: String)
}

class EditItemViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    weak var delegate: EditDetailDelegate?
    var mediaItem: MediaItem?
    var ratingValue = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupViews() {
       guard let mediaItem = mediaItem else {
          return
       }

       self.titleTextField.text = mediaItem.title
       self.ratingLabel.text = "Rating: \(mediaItem.rating)"
       self.ratingSlider.value = Float(mediaItem.rating)
       self.descriptionTextView.text = mediaItem.itemDescription
       self.ratingValue = mediaItem.rating
       self.yearTextField.keyboardType = .numberPad
       self.yearTextField.text = String(mediaItem.year)
    }
    
    @IBAction func ratingSliderAdjusted(_ sender: UISlider) {
        let roundedValue = Double(sender.value).roundTo(places: 1)
        if roundedValue != ratingValue {
           ratingValue = roundedValue
           ratingLabel.text = "Rating: \(ratingValue)"
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let delegate = self.delegate,
           let year = self.yearTextField.text,
           let title = self.titleTextField.text,
           let description = self.descriptionTextView.text else { return }
        if let year = Int(year) {
           delegate.mediaItemEdited(title: title, rating: ratingValue, year: year, description: description)
           self.navigationController?.popViewController(animated: true)
        } else {
           let alert = UIAlertController(title: "Uh oh!", message: "Invalid year", preferredStyle: .alert)
           let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
           alert.addAction(dismissAction)
           present(alert, animated: true)
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

}
