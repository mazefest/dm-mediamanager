//
//  MediaItemDetailViewController.swift
//  MediaManager
//
//  Created by Colby Mehmen on 6/1/23.
//

import UIKit

protocol DeleteItemDelegate: AnyObject {
   func deleteItem(mediaItem: MediaItem)
}


class MediaItemDetailViewController: UIViewController {
    var item: MediaItem?
    weak var delegate: DeleteItemDelegate?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var watchedButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
       guard let mediaItem = item else {
          return
       }

       self.titleLabel.text = mediaItem.title
       self.ratingLabel.text = String(mediaItem.rating)
       self.releaseYearLabel.text = "Released in \(mediaItem.year)"
       self.descriptionTextView.text = mediaItem.itemDescription
       descriptionTextView.isEditable = false

       if mediaItem.mediaType == "Movie" {
          self.deleteButton.setTitle("Delete Movie", for: .normal)
       } else {
          self.deleteButton.setTitle("Delete TV Show", for: .normal)
       }

       if mediaItem.isFavorite {
          self.favoriteButton.setTitle("Remove From Favorites", for: .normal)
       } else {
          self.favoriteButton.setTitle("Add To Favorites", for: .normal)
       }

       if mediaItem.wasWatched {
          self.watchedButton.setTitle("Mark As Unwatched", for: .normal)
       } else {
          self.watchedButton.setTitle("Mark As Watched", for: .normal)
       }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let mediaItem = item else {
           return
        }
        mediaItem.isFavorite = !mediaItem.isFavorite
        MediaItemController.shared.updateMediaItem()
        if mediaItem.isFavorite {
           DispatchQueue.main.async {
              self.favoriteButton.setTitle("Remove From Favorites", for: .normal)
           }
        } else {
           DispatchQueue.main.async {
              self.favoriteButton.setTitle("Add To Favorites", for: .normal)
           }
        }
    }
    
    @IBAction func reminderButtonTapped(_ sender: Any) {
        
    }
    

    @IBAction func watchedButtonTapped(_ sender: Any) {
        guard let mediaItem = item else {
           return
        }

        mediaItem.wasWatched = !mediaItem.wasWatched
        MediaItemController.shared.updateMediaItem()
        if mediaItem.wasWatched {
           self.watchedButton.setTitle("Mark As Unwatched", for: .normal)
        } else {
           self.watchedButton.setTitle("Mark As Watched", for: .normal)
        }
    }
     
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let mediaItem = item else {
           return
        }
        MediaItemController.shared.deleteMediaItem(mediaItem)
        delegate?.deleteItem(mediaItem: mediaItem)
        navigationController?.popViewController(animated: true)
    }
    
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toEditItemVC" {
            guard let destination = segue.destination as? EditItemViewController else {
                return
            }
            
            destination.mediaItem = item
            destination.delegate = self
            
        } else if segue.identifier == "toReminderView" {
            print("we are here")
            guard let destination = segue.destination as? DatePickerViewController else {
                return
            }
            destination.delegate = self
        }
    }
    

}

extension MediaItemDetailViewController: EditDetailDelegate {
    func mediaItemEdited(title: String, rating: Double, year: Int, description: String) {
        guard let mediaItem = self.item else { return }
        mediaItem.title = title
        mediaItem.rating = rating
        mediaItem.year = Int64(year)
        mediaItem.itemDescription = description

        MediaItemController.shared.updateMediaItem()

        setupViews()
    }
}

extension MediaItemDetailViewController: DatePickerDelegate {
    func reminderDateEdited(date: Date) {
        guard let mediaItem = self.item else { return }
        mediaItem.reminderDate = date
        reminderButton.setTitle("Edit Watch Reminder", for: .normal)
    }
}
