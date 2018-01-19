//
//  ProductsViewController.swift
//  test
//
//  Created by Developer on 1/19/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import CoreData

class ProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let appDalagate = UIApplication.shared.delegate as! AppDelegate
    var products: [NewProduct] = [NewProduct]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let newProductFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "NewProduct")
        do {
            products = try appDalagate.persistentContainer.viewContext.fetch(newProductFetch) as! [NewProduct]
        } catch { }
        tableView.reloadData()
    }
    
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        
        let product = products[indexPath.row]
        
        if let image = product.images?.first(where: { _ in true }) as? Image {
            if let imageData = image.imageData {
                cell.imageView?.image = UIImage(data: imageData)
            }
        }
        
        cell.textLabel?.text = product.name
        
        return cell
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "productSegue", sender: products[indexPath.row])
    }

    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vievController = segue.destination as? ProductViewController, let product = sender as? NewProduct {
            vievController.product = product
        }
    }

}

