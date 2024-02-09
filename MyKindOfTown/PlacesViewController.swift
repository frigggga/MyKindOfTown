//
//  PlacesViewController.swift
//  MyKindOfTown
//
//  Created by Zhang on 2024/2/5.
//

import UIKit

class PlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: PlacesFavoritesDelegate?
 
    @IBAction func dismissButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "places")
        tableView.dataSource = self
        self.view.addSubview(tableView)


    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.sharedInstance.listFavorites().count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "places", for: indexPath)
        let list = DataManager.sharedInstance.listFavorites()
        cell.textLabel!.text = list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = DataManager.sharedInstance.listFavorites()
        delegate?.favoritePlace(name: list[indexPath.row])
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let list = DataManager.sharedInstance.listFavorites()
            DataManager.sharedInstance.deleteFavorite(list[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

}
