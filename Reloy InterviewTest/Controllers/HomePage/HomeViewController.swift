//
//  HomeViewController.swift
//  Reloy InterviewTest
//
//  Created by Santhosh K on 19/06/22.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionViewImgList: UICollectionView!
    
    //MARK:- variables
    private let spacing:CGFloat = 5.0
    var apiResult:PixabayApiResponse? = nil
    var imageList:[PixabayApiImageList]? = nil
    
    //MARK:- ViewMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCCell()
        self.homePageListingApi()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.title = "Home"
    }
    
    
    override func viewWillTransition(to size: CGSize,
                                 with coordinator: UIViewControllerTransitionCoordinator)
    {
          super.viewWillTransition(to: size, with: coordinator)
          collectionViewImgList?.collectionViewLayout.invalidateLayout()
    }
    
    //MARK:- Func
    func setupCCell() {
        ImageListCCell.registerWithCollectionView(collectionViewImgList)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionViewImgList?.collectionViewLayout = layout
    }
}

//MARK:- CollectionView delegateMenu
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageListCCell = collectionView.dequeueReusable(for: indexPath)
        if let allImages = self.imageList {
            cell.imgView.load(allImages[indexPath.row].previewURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        if let allImages = self.imageList {
            next.imageDetails = allImages[indexPath.row]
            self.navigationController?.pushViewController(next, animated: true)
            
            //OR - Present
            
            // next.modalPresentationStyle = .fullScreen
           // self.present(next, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfItemsPerRow:CGFloat = 2
        var AdjustnumberOfItemsSpace = numberOfItemsPerRow - 1
        let spacingBetweenCells:CGFloat = self.spacing
        if UIDevice.current.orientation.isLandscape {
            numberOfItemsPerRow = 3
            AdjustnumberOfItemsSpace = numberOfItemsPerRow
        }
        let totalSpacing = (2 * self.spacing) + ((AdjustnumberOfItemsSpace) * spacingBetweenCells) //Amount of total spacing in a row
        if let collection = self.collectionViewImgList{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}



//MARK:- API_Call
extension HomeViewController {
    //search
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.becomeFirstResponder()
        if let searchText = textField.text {
            if searchText.trimmingCharacters(in: .whitespaces) != "" && searchText.count >= 2 {
                self.homePageListingApi(searchText)
            }
            else {
                if searchText.trimmingCharacters(in: .whitespaces) == "" {
                    self.homePageListingApi(searchText)
                }
            }
        }
    }
   
    //API call
    func homePageListingApi(_ searchText:String = ""){
        let homeApi = "\(APIURL.imageListing)?key=\(userID)&q=\(searchText)&image_type=all"
        print("Start")
        RequestManager().methodType(requestType: .GET, homeApi, params:[:], paramsData: nil, completion: { (responseJson, responseData, statusCode) in
            
            print(responseJson as Any)
            if responseData != nil {
                DispatchQueue.main.async {
                    do {
                        let result = try JSONDecoder().decode(PixabayApiResponse.self, from: responseData!)
                        self.imageList = result.hits
                        self.collectionViewImgList.reloadData()
                    }
                    catch let jsonErr {
                        print(jsonErr)
                    }
                }
            }
        }) { (responseJson, responseData, statusCode) in
            print("Error")
        }
    }
}
