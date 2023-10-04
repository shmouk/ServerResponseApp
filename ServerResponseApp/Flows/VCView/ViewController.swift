import UIKit

class ViewController: UIViewController {
    private let dataSource = TableViewDataSource()
    private let viewModel = ViewModel()
    private let cellId = "defaultCell"
    
    lazy var tableView = InterfaceBuilder.makeTableView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
    }
    
    private func setUI() {
        setSubviews()
        settingTableView()
        setupConstraints()
    }
    
    private func settingTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func setSubviews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    func loadData() {
        viewModel.receiveInfo()
    }
    
    func bindViewModel() {
        viewModel.data.bind { [weak self] newData in
            guard let self = self else { return }
            dataSource.data = newData
            tableView.reloadData()

        }
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = tableView.frame.size.height
        
        if offsetY > contentHeight - tableViewHeight {
            loadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let typeId = dataSource.data.userInfo[indexPath.row].typeId
        viewModel.captureData(self, id: typeId)
    }
}



