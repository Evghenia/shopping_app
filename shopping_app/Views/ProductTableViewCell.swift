//
//  ProductTableViewCell.swift
//  shopping_app
//
//  Created by Evghenia Moroz on 10/15/20.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(product: Product) {
        productName.text = product.productName
        priceLabel.text = "$\(String(describing: product.salesPriceIncVat))"
        if let imageData = try? Data(contentsOf:  URL(string:product.productImage)!) {
            if let image = UIImage(data: imageData) {
                productImage.image = image
            }
        }
    }
    
}
