//
//  ViewController.swift
//  MyBase
//
//  Created by Felipe Mota on 08/03/18.
//  Copyright © 2018 Felipe Mota. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func login(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            
            print("Acabei de logar")
        })
    }
    
    @IBAction func cadastro(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, eroor) in
            
            print("usuario criado")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "GroupToDoList", sender: nil)
            }
        })
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

