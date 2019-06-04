//
//  ViewController.swift
//  Earthquakes
//
//  Created by 胜的钱 on 2019/6/3.
//  Copyright © 2019 胜的钱. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    var coredatas : [Quake] = []
    
    var container : NSPersistentContainer!
    var managedObjectContext : NSManagedObjectContext!
    lazy var tableView : UITableView = {
        let view = UITableView(frame: CGRect(x: 140, y: 0, width: self.view.frame.width - 140, height: self.view.frame.height))
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "CoreDataCell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = container.viewContext
        let addbtn = UIButton(frame: CGRect(x: 15, y: 70, width: 120, height: 36))
        addbtn.backgroundColor = UIColor.blue
        addbtn.setTitle("添加一条记录", for: .normal)
        addbtn.addTarget(self, action: #selector(clickAddAction), for: .touchUpInside)
        
        let deletebtn = UIButton(frame: CGRect(x: 15, y: 120, width: 120, height: 36))
        deletebtn.backgroundColor = UIColor.blue
         deletebtn.setTitle("删除一条记录", for: .normal)
        deletebtn.addTarget(self, action: #selector(clickDeleteAction) , for: .touchUpInside)
        
        let searchbtn = UIButton(frame: CGRect(x: 15, y: 170, width: 120, height: 36))
        searchbtn.backgroundColor = UIColor.blue
         searchbtn.setTitle("查询一条记录", for: .normal)
        searchbtn.addTarget(self, action: #selector(clickSearchction), for: .touchUpInside)
        
        let updatebtn = UIButton(frame: CGRect(x: 15, y: 220, width: 120, height: 36))
        updatebtn.backgroundColor = UIColor.blue
        updatebtn.setTitle("更新一条记录", for: .normal)
        updatebtn.addTarget(self, action: #selector(clickUpdateAction), for: .touchUpInside)

        self.view.addSubview(addbtn)
        self.view.addSubview(deletebtn)
        self.view.addSubview(searchbtn)
        self.view.addSubview(updatebtn)
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        self.view.addSubview(tableView)
        
    }

    
    @objc func clickAddAction() {
        addQuakeEntiy()
    }
    
    func addCoutryEntiy() {
        // CoreData 新增数据
        guard let entiy = NSEntityDescription.entity(forEntityName: "Country", in: managedObjectContext) else { return }
        let country = NSManagedObject(entity: entiy, insertInto: managedObjectContext) as? Country
        country?.name = "china"
        //country.setValue("china", forKey: "name")
        
        do {
            try  managedObjectContext.save()
        } catch  {
            fatalError("not saved")
        }
    }
    
    func addQuakeEntiy() {
        // CoreData 新增数据
        guard let entiy = NSEntityDescription.entity(forEntityName: "Quake", in: managedObjectContext) else { return }
        let quake = NSManagedObject(entity: entiy, insertInto: managedObjectContext) as? Quake
        quake?.magnitude = Float(arc4random() % 9)
        quake?.place = "Something"
        //country.setValue("china", forKey: "name")
        
        do {
            try  managedObjectContext.save()
        } catch  {
            fatalError("not saved")
        }
    }
    
    @objc func clickDeleteAction() {
        let result : NSFetchRequest<Quake> = Quake.fetchRequest()
        let predicate = NSPredicate(format: "magnitude >= 5.0")
        result.predicate = predicate
        do {
             let results  = try managedObjectContext.fetch(result)
            results.forEach { (couty) in
                managedObjectContext.delete(couty)
            }
            coredatas = results
            tableView.reloadData()
        } catch let error as NSError {
            print("error: \(error),\(error.userInfo)")
        }
    }
    
    @objc func clickSearchction() {
        // CoreData查询数据
        let fetchs : NSFetchRequest<Quake>  = Quake.fetchRequest()
        do {
            let results = try managedObjectContext.fetch(fetchs)
            coredatas = results
            tableView.reloadData()
            
        } catch {
            fatalError("获取失败")
        }
    }
    
    @objc func clickUpdateAction() {
        let result : NSFetchRequest<Quake> = Quake.fetchRequest()
        do {
            let results  = try managedObjectContext.fetch(result)
            results.forEach { (couty) in
                couty.place =  "Month"
            }
            coredatas = results
            tableView.reloadData()
        } catch let error as NSError {
            print("error: \(error),\(error.userInfo)")
        }
    }

    //MARK: - tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coredatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoreDataCell")
        cell?.textLabel?.text = (coredatas[indexPath.row].place ?? "some") + " \(coredatas[indexPath.row].magnitude)"
        return cell!
        
    }

}

