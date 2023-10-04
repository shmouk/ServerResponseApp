import UIKit

class TableViewDataSource: NSObject, UITableViewDataSource {
    let cellId = "defaultCell"
    var data = InfoModel()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.pageSize
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let item = data.userInfo[indexPath.row]
        cell.textLabel?.text = item.name
        cell.textLabel?.textColor = .black
        cell.imageView?.image = item.photo
        cell.backgroundColor = .lightGray
        return cell
    }
}
