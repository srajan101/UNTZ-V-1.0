//
//  PoptableViewController.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 28/02/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

protocol PoptableViewDelegate: class {
    func selectedTableId(_ selectedrow: Int?)
    func closeView()
}
class PoptableViewController: UIViewController , UITableViewDelegate ,UITableViewDataSource {
    
    
    //@IBOutlet weak var tracksTableView: UITableView!
    var myTableView: UITableView!
    fileprivate var texts = ["Edit", "Delete", "Report"]
    var eventPlayListArray = NSMutableArray()
    weak var delegate: PoptableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)

        // Do any additional setup after loading the view.
        
    }
    func buttonAction(sender: UIButton!) {
        print("close popup")
        self.closewithAnimation()
    }
    func closewithAnimation(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
                self.delegate?.closeView()
            }
        });
    }
    func setTableviewframe(xval:CGFloat , yval:CGFloat , array:NSMutableArray,height:CGFloat){
        eventPlayListArray = array
        myTableView = UITableView(frame: CGRect(x: xval, y: yval, width: (xval-20), height: height))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.rowHeight = 40.0
        myTableView.layer.cornerRadius = 3.5
        myTableView.layer.borderWidth = 1.5
        myTableView.layer.borderColor = UIColor.black.cgColor
        myTableView.layer.masksToBounds = true
        self.view.addSubview(myTableView)
        myTableView.reloadData()
    }
    override func viewDidLayoutSubviews(){
        //myTableView.frame = CGRect(x: myTableView.frame.origin.x, y: myTableView.frame.origin.y, width: myTableView.frame.size.width, height: myTableView.contentSize.height)
        myTableView.reloadData()
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventPlayListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let infoObj = eventPlayListArray.object(at: (indexPath as NSIndexPath).row) as? UNEventPlaylistInfo
        cell.textLabel?.text = infoObj?.playlistName
        cell.textLabel?.font = Theme.getRobotoRegular(size: 15)
        cell.textLabel?.textColor = UIColor.black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("row clicked")
         delegate?.selectedTableId(indexPath.row)
        self.closewithAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

