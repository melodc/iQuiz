//
//  ViewController.swift
//  iquiz
//
//  Created by Melody Chou on 5/6/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var settingsItem: UINavigationItem!
    
    let subjects = [
        "Mathematics",
        "Marvel Super Heroes",
        "Science"
    ]
    
    let descriptions = [
        "From simple adding and subtracting, to Taylor Series",
        "How well do you know your Marvel Super Heroes, both old and new?",
        "Put your science smarts under the microscope and see how much you know about biology, chemistry, and physics!"
    ]
     
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func onSettingsClick(_ sensder: UIBarButtonItem) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in }))

        self.present(alert, animated: true, completion: nil)
    }
    

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("you tapped on the first row")
            let vc = storyboard?.instantiateViewController(identifier: "game") as! GameViewController
            vc.subject = "math"
            vc.currQuestionNum = 0
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } else {
            // do something when any other row is tapped
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.imageView?.image = UIImage(named: subjects[indexPath.row])
        cell.textLabel?.text = subjects[indexPath.row]
        cell.detailTextLabel?.text = descriptions[indexPath.row]
        
        // line break for detail text
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping

        return cell
    }
    
}

class MyTableViewCell: UITableViewCell {

    // resize table cell height to be based on the height of
    // subtitle label in cell
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {

        self.layoutIfNeeded()
        var size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)

        if let textLabel = self.textLabel, let detailTextLabel = self.detailTextLabel {
            let detailHeight = detailTextLabel.frame.size.height
            if detailTextLabel.frame.origin.x > textLabel.frame.origin.x { // style = Value1 or Value2
                let textHeight = textLabel.frame.size.height
                if (detailHeight > textHeight) {
                    size.height += detailHeight - textHeight
                }
            } else { // style = Subtitle, so always add subtitle height
                size.height += detailHeight
            }
        }

        return size

    }

}
