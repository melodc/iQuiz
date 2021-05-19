//
//  ViewController.swift
//  iquiz
//
//  Created by Melody Chou on 5/6/21.
//

import UIKit

struct Question: Codable {
    let text: String
    let answer: String
    let answers: [String]
}

struct Subject: Codable {
    let title: String
    let desc: String
    let questions: [Question]
}


class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var settingsItem: UINavigationItem!
    
    var allData:[Subject] = []
    
    var subjects:[String] = []
    var descriptions:[String] = []
     
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    @IBAction func onSettingsClick(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Settings", message: "Add Question Bank Here", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter URL containing JSON file"
            }
        
        let checkNow = UIAlertAction(title: "Check Now", style: UIAlertAction.Style.default, handler: { alert -> Void in
                let input = alertController.textFields![0] as UITextField
            if let url = URL(string: input.text!) {
                URLSession.shared.dataTask(with: url) { [self] data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let decodedData = try jsonDecoder.decode([Subject].self, from: data)
                        
                        // local storage
                        UserDefaults.standard.set(try? PropertyListEncoder().encode(decodedData), forKey:"bank")
                        
                        self.allData = decodedData
                        self.subjects = decodedData.map { $0.title }
                        self.descriptions = decodedData.map { $0.desc }
                        print(self.subjects)
                        print(self.descriptions)
                        DispatchQueue.main.async {
                                self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
            }
            })

        
        alertController.addAction(checkNow)
        

        self.present(alertController, animated: true, completion: {
            alertController.view.superview?.isUserInteractionEnabled = true
            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "game") as! GameViewController
        vc.subject = subjects[indexPath.row]
        vc.gameModels = allData[indexPath.row].questions
        vc.currQuestionNum = 0
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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

//class MyTableViewCell: UITableViewCell {
//
//    // resize table cell height to be based on the height of
//    // subtitle label in cell
//    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//
//        self.layoutIfNeeded()
//        var size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
//
//        if let textLabel = self.textLabel, let detailTextLabel = self.detailTextLabel {
//            let detailHeight = detailTextLabel.frame.size.height
//            if detailTextLabel.frame.origin.x > textLabel.frame.origin.x { // style = Value1 or Value2
//                let textHeight = textLabel.frame.size.height
//                if (detailHeight > textHeight) {
//                    size.height += detailHeight - textHeight
//                }
//            } else { // style = Subtitle, so always add subtitle height
//                size.height += detailHeight
//            }
//        }
//
//        return size
//
//    }
//
//}
