//
//  DetailViewController.swift
//  Reloy InterviewTest
//
//  Created by Santhosh K on 19/06/22.
//

import UIKit

class DetailViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var tableviewApiList: UITableView!
    @IBOutlet weak var dismissBtn: UIButton!
    
    //MARK:- variables
    var imageDetails:PixabayApiImageList? = nil
    
    //MARK:- ViewMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissBtn.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.registerTableviewCell()
    }
    
    
    //MARK:- IBActions
    @IBAction func onClickDismisBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //MARK:- Func
    func registerTableviewCell() {
        DetailHeaderTCell.registerWithTable(tableviewApiList)
    }
    
}


//MARK:- Tableview Delegates
extension DetailViewController:UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(DetailHeaderTCell.self)
        if let img = imageDetails {
            cell.displayImg.load(img.largeImageURL)
            cell.userNameLbl.text = img.user
            cell.descriptionLbl.text = img.tags
            cell.resolutionLbl.text = "\(img.imageWidth)x\(img.imageHeight)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}


