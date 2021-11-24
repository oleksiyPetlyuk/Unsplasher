//
//  SettingsTableViewController.swift
//  Unsplasher
//
//  Created by Oleksiy Petlyuk on 23.11.2021.
//

import UIKit

protocol SettingsDisplayLogic: AnyObject {
  func displaySettings(viewModel: Settings.ViewModel)
}

class SettingsTableViewController: UITableViewController, SettingsDisplayLogic {
  var interactor: SettingsBusinessLogic?

  var selectedTheme: ApplicationTheme?
  let pickerView = UIPickerView()

  // MARK: - Outlets

  @IBOutlet weak var currentThemeTextField: UITextField!

  // MARK: - Object lifecycle

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    setup()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    setup()
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    getSettings()
    setupPickerView()
  }

  // MARK: - Setup

  private func setup() {
    let viewController = self
    let interactor = SettingsInteractor()
    let presenter = SettingsPresenter()

    viewController.interactor = interactor
    interactor.presenter = presenter
    presenter.viewController = viewController
  }

  func getSettings() {
    interactor?.getSettings()
  }

  func displaySettings(viewModel: Settings.ViewModel) {
    let settings = viewModel.settings

    selectedTheme = settings.theme
    currentThemeTextField.text = settings.theme.rawValue
  }
}

extension SettingsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func setupPickerView() {
    pickerView.delegate = self
    pickerView.dataSource = self

    if let selectedTheme = selectedTheme, let row = ApplicationTheme.allCases.firstIndex(of: selectedTheme) {
      pickerView.selectRow(row, inComponent: 0, animated: false)
    }

    currentThemeTextField.inputView = pickerView

    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(changeTheme))
    toolBar.setItems([button], animated: true)
    currentThemeTextField.inputAccessoryView = toolBar
  }

  @objc func changeTheme() {
    if let theme = selectedTheme {
      interactor?.changeTheme(request: .init(theme: theme))
      currentThemeTextField.resignFirstResponder()
    }
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return ApplicationTheme.allCases.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return ApplicationTheme.allCases[row].rawValue
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedTheme = ApplicationTheme.allCases[row]
  }
}
