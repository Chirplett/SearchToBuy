//
//  SearchResultViewController.swift
//  SearchToBuy
//
//  Created by Jude Song on 7/27/25.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    var typedText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = typedText
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
