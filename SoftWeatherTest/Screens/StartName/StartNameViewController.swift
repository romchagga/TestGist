//
//  StartNameViewController.swift
//  SoftWeatherTest
//
//  Created by macbook on 21.02.2023.
//

import UIKit

class StartNameViewController: UIViewController {

    let textFieldName: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Введите ваше имя пользователя"
        textfield.backgroundColor = .lightGray
        textfield.translatesAutoresizingMaskIntoConstraints = false
        let paddingView = UIView(frame: CGRectMake(0, 0, 5, 0))
        textfield.leftView = paddingView
        textfield.leftViewMode = UITextField.ViewMode.always
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        return textfield
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти", for: .normal)
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setConstraint()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        textFieldName.text = ""
    }
    
    @objc func buttonTapped() {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [
        createTabBar(vc: PublicListViewController(), title: "Public", image: "list.dash"),
        createTabBar(vc: OwnListViewController(), title: "Own", image: "person.fill.turn.down")
        
        ]
        navigationController?.pushViewController(tabBar, animated: true)
    }

    func createTabBar(vc: UIViewController, title: String, image: String) -> UIViewController {
        let item = UITabBarItem(title: title, image: UIImage(systemName: image)?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0)), tag: 0)
        
        
        item.titlePositionAdjustment = .init(horizontal: 0, vertical: 10)
        
        vc.tabBarItem = item
        
        return vc
        
        
    }
    
    func setConstraint() {
        view.addSubview(textFieldName)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            textFieldName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldName.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 20),
            button.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

}
