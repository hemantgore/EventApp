//
//  EditEventViewController.swift
//  EventApp
//
//  Created by Hemant Gore on 26/05/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import UIKit

final class EditEventViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: EditEventViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.viewDidLoad()

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }

    func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TitleSubtitleCell.self, forCellReuseIdentifier: "TitleSubtitleCell")
        tableView.tableFooterView = UIView()

        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
        navigationController?.navigationBar.tintColor = .black
        // to force large title
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.setContentOffset(.init(x: 0, y: -2), animated: false)

    }

    @objc
    func tappedDone() {
        viewModel.tappedDone()
    }
    deinit {
        print("Edit Event VCC deinit")
    }
}

extension EditEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellVM = viewModel.cell(for: indexPath)

        switch cellVM {
        case .titleSubtitle(let titleSubtitleVM):
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleSubtitleCell", for: indexPath) as! TitleSubtitleCell
            cell.update(with: titleSubtitleVM)
            cell.subtitleTextField.delegate = self
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

}

extension EditEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
extension EditEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {
            return false
        }
        let text = currentText + string

        let point = textField.convert(textField.bounds.origin, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            viewModel.update(indexPath: indexPath, subtitle: text)
        }
        return true
    }
}
