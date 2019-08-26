//
//  ViewController.swift
//  CollectionView
//
//  Created by Brian on 7/13/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet private weak var collectionView: UICollectionView!
  @IBOutlet private weak var addButton: UIBarButtonItem!
  
  @IBOutlet private weak var btnDeleteItems : UIBarButtonItem!

  var collectionData = ["1🏆" , "2 🐸", "3 🍩", "4 😸", "5 🤡", "6 👾", "7 👻",
                        "8 🍖", "9 🎸", "10 🐯", "11 🐷", "12 🌋"]

  @IBAction func addItem() {
    collectionView.performBatchUpdates({
      for _ in 0 ..< 2 {
        let text = "\(collectionData.count + 1) 😸"
        
        // 1 .add new data to backing data model
        collectionData.append(text)
        
        // 2. update de collection view
        let indexPath = IndexPath(row: collectionData.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
      }
    }, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  
    setupSizelayoutCell()
    addRefreshControl()
    navigationItem.leftBarButtonItem = editButtonItem
    navigationController?.isToolbarHidden = true
  }
  
  private func setupSizelayoutCell(){
    // add layout size of the cell
    let width = (view.frame.size.width - 20) / 3
    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.itemSize = CGSize(width: width, height: width)
    
    
  }
  
  @IBAction private func deletSelected(){
    if let selected = collectionView.indexPathsForSelectedItems{
      
      // delete the rows of the data
      let arrItems = selected.map {($0.item)}.sorted().reversed()
      for item in arrItems{
        collectionData.remove(at: item)
      }
      
      // delete of the collectionView
      collectionView.deleteItems(at: selected)
    }
    
    navigationController?.isToolbarHidden = true
  }
  
  func addRefreshControl(){
    let refresh = UIRefreshControl()
    refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    collectionView.refreshControl = refresh
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    
    addButton.isEnabled = !editing                    // disable add item
    btnDeleteItems.isEnabled = editing
    navigationController?.isToolbarHidden = !editing
    
    collectionView.indexPathsForSelectedItems?.forEach{
      collectionView.deselectItem(at: $0, animated: false)
    }
    setEditingModeCellsVisibles(bEditing: editing)
  }
  
  func setEditingModeCellsVisibles(bEditing : Bool){
    collectionView.allowsMultipleSelection = bEditing // select multiples rows
    
    let indexPaths = collectionView.indexPathsForVisibleItems
    for indexPath in indexPaths {
      if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell{
        cell.isEditing = bEditing    // show the circle image to select mode
      }
    }
  }
  

  @objc func refresh() {
    addItem()  // 1. add items to the collection view
    collectionView.refreshControl?.endRefreshing()     // 2. End refreshing
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return collectionData.count
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell{
      cell.titleLabel.text = collectionData[indexPath.row]
      cell.isEditing = isEditing
      return cell
    }
    return UICollectionViewCell()
  
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if !isEditing {
      performSegue(withIdentifier: "DetailSegue", sender: indexPath)
    }
    else{
      navigationController?.isToolbarHidden = false
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    
    if isEditing{
      if let selected = collectionView.indexPathsForSelectedItems,
        selected.count == 0{
        navigationController?.isToolbarHidden = true
      }
    }
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
    if segue.identifier == "DetailSegue" {
      if let dest = segue.destination as? DetailViewController, let index = sender as? IndexPath {
      
        dest.selection = collectionData[index.row]
      }
    }
  
  }
  
  
}

