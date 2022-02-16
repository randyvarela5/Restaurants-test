//
//  LunchViewController.swift
//  BR Eng Test
//
//  Created by Randy Varela on 1/21/22.
//  collectionView of the restaurants

import UIKit


class LunchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var restaurants: [Restaurant] = []
    var selectedRestaurant: Restaurant?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        collectionView.dataSource = self
        collectionView.delegate = self
        navigationItem.title = "Lunch Tyme"
        
        func configureItems() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_map"), style: .done, target: self, action: nil)
        }
        
        guard let url = URL(string: "https://s3.amazonaws.com/br-codingexams/restaurants.json#") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            if error == nil{
                
                do {
                    self.restaurants = try JSONDecoder().decode(RestaurantsData.self, from: data).restaurants
                } catch let jsonError {
                    print(jsonError)
                }
                
                DispatchQueue.main.async {
                    print(self.restaurants.count)
                    self.collectionView.reloadData()
                }
            }
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.restaurantLabel.text = restaurants[indexPath.row].name
        cell.imageView.contentMode = .scaleAspectFit
        cell.categoryLabel.text = restaurants[indexPath.row].category
        
        let completeLink = restaurants[indexPath.row].backgroundImageURL
        
        cell.imageView.downloaded(from: completeLink)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedRestaurant = restaurants[indexPath.row]
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.restaurant = self.selectedRestaurant
        }
    }
}

extension UIImageView {
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
        contentMode = mode
        if let imageData = ImageCache.shared.images[url.absoluteString], let image = UIImage(data: imageData) {
            print("Using Cached images")
            self.image = image
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else { return }
                ImageCache.shared.images[url.absoluteString] = data
                DispatchQueue.main.async() { [weak self] in
                    
                    self?.image = image
                }
            }.resume()
        }
    }
}


