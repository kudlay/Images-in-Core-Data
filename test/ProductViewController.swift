//
//  ProductViewController.swift
//  test
//
//  Created by Developer on 1/19/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import CoreData

class ProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    
    let appDalagate = UIApplication.shared.delegate as! AppDelegate
    
    var product: NewProduct? {
        didSet {
            _product = product
            if let imagesAsDataSet = _product?.images?.value(forKey: "imageData") as? Set<Data> {
                imageDatas = Array(imagesAsDataSet)
            }
        }
    }
    
    private var _product: NewProduct?
    
    var images: [UIImage] = [UIImage]()
    
    var imageDatas: [Data] {
        get {
            var result: [Data] = [Data]()
            for image in images {
                if let data = UIImagePNGRepresentation(image) {
                    result.append(data)
                }
            }
            return result
        } set {
            var result: [UIImage] = [UIImage]()
            for imageData in newValue {
                if let image = UIImage(data: imageData) {
                    result.append(image)
                }
            }
            images = result
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.text = _product?.name
        collectionView.reloadData()
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.clipsToBounds  = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = images[indexPath.row]
        cell.addSubview(imageView)
        return cell
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            images.append(chosenImage)
            collectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }

    
    //MARK: Actions
    @IBAction func openGalery() {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func save() {

        if _product == nil {
            _product = (NSEntityDescription.insertNewObject(forEntityName: "NewProduct", into: appDalagate.persistentContainer.viewContext) as! NewProduct)
        }
        
        _product?.name = textField.text
        
        var imagesSet = [Image]()
        for data in imageDatas {
            let image = (NSEntityDescription.insertNewObject(forEntityName: "Image", into: appDalagate.persistentContainer.viewContext) as! Image)
            image.imageData = data
            imagesSet.append(image)
        }
        
        _product?.images = NSSet(array: imagesSet)
        
        appDalagate.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hideKeyboard() {
        view.endEditing(true)
    }
}
