//
//  ProductsListController.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/4/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class ProductsListController: UITableViewController {
    
    static let storyBoardIdentifier: String = "ProductsList"
    
    var category: Category? {
        didSet {
            setUpSearchByCategory()
        }
    }
    
    var products: [Product] = [Product]()
    
    let cartButton: UIButton = {
        let img = UIImage(named: "shopcart")
        let btn = UIButton()
        btn.setImage(img, for: .normal)
        btn.imageView!.contentMode = .scaleAspectFit
        btn.imageView!.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let spinnerView: SpinnerView = SpinnerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavBar()
        spinnerView.showSpinner(in: self.view)
        tableSetUp()
    }
    
    // MARK: - Set Up
    func setUpNavBar() {
        setUpCartIcon()
    }
    
    func setUpCartIcon() {
        cartButton.addTarget(self, action: #selector(onCartPressed), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        
        let margins = navigationController?.navigationBar.layoutMargins
        NSLayoutConstraint.activate([
            cartButton.imageView!.heightAnchor.constraint(equalToConstant: navigationController!.navigationBar.frame.height - margins!.right * 2),
            cartButton.widthAnchor.constraint(equalToConstant: navigationController!.navigationBar.frame.height + margins!.right)
        ])
    }
    
    func tableSetUp() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    func setUpSearchByCategory() {
        title = category?.name
        //spinnerView.showSpinner(in: self.view)
        downloadItemsByCategory()
    }
    
    // MARK: Data Handlers
    func downloadItemsByCategory() {
        ProductsAPI.getMockItemsByCategory(id: category!.id){ items in
            self.spinnerView.stopSpinner()
            self.products = items!
            self.tableView.reloadData()
            
            if items?.count == 0 {
                let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                let messageLabel = UILabel(frame: rect)
                messageLabel.text = "No Items For Department"
                messageLabel.textColor = .black
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = .center;
                messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
                messageLabel.sizeToFit()

                self.tableView.backgroundView = messageLabel;
                self.tableView.separatorStyle = .none;
            }
        }
    }
    
    // MARK: Action Handlers
    @objc func onCartPressed(sender: UIBarButtonItem) {
        print("Here")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableCellView.identifier, for: indexPath) as! ProductTableCellView

        cell.product = products[indexPath.row]

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
