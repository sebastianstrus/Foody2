import UIKit
import Cosmos
import MapKit
//import PlaygroundSupport

class AddMealViewController : UIViewController {
    
    // scroll view
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        //sv.contentSize.height = 2000 // automatically
        return sv
    }()
    
    // all views
    private let titleTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter title".localized
        tf.backgroundColor = .white
        tf.setLeftPaddiingPoints(Device.IS_IPHONE ? 20 : 40)
        return tf
    }()
    
    private let mealImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "table"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        
        return iv
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton(title: "Camera".localized, color: AppColors.DODGER_BLUE)
        return button
    }()
    
    private let libraryButton: UIButton = {
        let button = UIButton(title: "Library".localized, color: AppColors.DODGER_BLUE)
        return button
    }()
    
    
    private let cosmosView: CosmosView = {
        let cv = CosmosView()
        cv.settings.updateOnTouch = true
        cv.settings.fillMode = .half
        cv.settings.starSize = 40
        cv.settings.starMargin = 10
        cv.settings.filledColor = UIColor.orange
        cv.settings.emptyBorderColor = UIColor.orange
        cv.settings.filledBorderColor = UIColor.orange
        cv.backgroundColor = .white
        return cv
    }()
    
    private let selectDateButton: UIButton = {
        let button = UIButton(title: "Select date".localized, color: AppColors.DODGER_BLUE)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        //set current Date as default
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        label.text = formatter.string(from: date)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Add description:".localized
        return label
    }()
    
    private let favoriteLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorite?".localized
        return label
    }()
    
    private let favoriteSwitch: UISwitch = {
        let sw = UISwitch()
        return sw
    }()
    
    private let mealDescriptionTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "It was very tasty. :)".localized
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    private let mapView: MKMapView = {
        let mv = MKMapView()
        mv.layer.borderWidth = 1
        mv.layer.cornerRadius = 5
        mv.layer.borderColor = UIColor.lightGray.cgColor
        return mv
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(title: "Save meal".localized, color: AppColors.DODGER_BLUE)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(title: "Add meal".localized)
        setupScrollView()
        setupViews()
        
        //handle keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(AddMealViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddMealViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.setAnchor(top: view.safeTopAnchor,
                             leading: view.safeLeadingAnchor,
                             bottom: view.safeBottomAnchor,
                             trailing: view.safeTrailingAnchor,
                             paddingTop: 0,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 0)
    }
    
    private func setupViews() {
        [titleTF, mealImageView, cameraButton, libraryButton, cosmosView, selectDateButton, dateLabel, mealDescriptionTF, descriptionLabel, favoriteLabel, favoriteSwitch, mapView, saveButton].forEach({scrollView.addSubview($0)})

        //title textField
        titleTF.translatesAutoresizingMaskIntoConstraints = false
        titleTF.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        titleTF.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        titleTF.heightAnchor.constraint(equalToConstant: Device.IS_IPHONE ? 40 : 80).isActive = true
        titleTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
        //image
        mealImageView.setAnchor(top: titleTF.bottomAnchor,
                                leading: nil,
                                bottom: nil,
                                trailing: nil,
                                paddingTop: 20,
                                paddingLeft: 0,
                                paddingBottom: 0,
                                paddingRight: 0)
        mealImageView.widthAnchor.constraint(equalTo: titleTF.widthAnchor).isActive = true
        mealImageView.heightAnchor.constraint(equalTo: titleTF.widthAnchor).isActive = true
        mealImageView.centerXAnchor.constraint(equalTo: titleTF.centerXAnchor).isActive = true
        mealImageView.alpha = 0.4
        
        // camera and library buttons
        cameraButton.setAnchor(top: mealImageView.bottomAnchor,
                               leading: mealImageView.leadingAnchor,
                               bottom: nil,
                               trailing: nil,
                               paddingTop: 10,
                               paddingLeft: 20,
                               paddingBottom: 0,
                               paddingRight: 0,
                               width: CGFloat(Device.SCREEN_WIDTH/4),
                               height: Device.IS_IPHONE ? 32 : 64)
        libraryButton.setAnchor(top: mealImageView.bottomAnchor,
                                leading: nil,
                                bottom: nil,
                                trailing: mealImageView.trailingAnchor,
                                paddingTop: 10,
                                paddingLeft: 0,
                                paddingBottom: 0,
                                paddingRight: 20,
                                width: CGFloat(Device.SCREEN_WIDTH/4),
                                height: Device.IS_IPHONE ? 32 : 64)
        
        //cosmos view
        cosmosView.setAnchor(top: cameraButton.bottomAnchor,
                             leading: nil,
                             bottom: nil,
                             trailing: nil,
                             paddingTop: 10,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 0,
                             width: 0,
                             height: 0)
        cosmosView.centerXAnchor.constraint(equalTo: mealImageView.centerXAnchor).isActive = true
        
        //date info
        selectDateButton.setAnchor(top: cosmosView.bottomAnchor,
                                   leading: mealImageView.leadingAnchor,
                                   bottom: nil,
                                   trailing: nil,
                                   paddingTop: Device.IS_IPHONE ? 10 : 20,
                                   paddingLeft: 0,
                                   paddingBottom: 0,
                                   paddingRight: 0,
                                   width: Device.IS_IPHONE ? 100 : 200,
                                   height: Device.IS_IPHONE ? 32 : 64)
        dateLabel.setAnchor(top: nil,
                            leading: selectDateButton.trailingAnchor,
                            bottom: nil,
                            trailing: nil,
                            paddingTop: 10,
                            paddingLeft: 10,
                            paddingBottom: 0,
                            paddingRight: 0,
                            width: Device.IS_IPHONE ? 100 : 200,
                            height: Device.IS_IPHONE ? 32 : 64)
        dateLabel.centerYAnchor.constraint(equalTo: selectDateButton.centerYAnchor).isActive = true
        
        descriptionLabel.setAnchor(top: selectDateButton.bottomAnchor, leading: selectDateButton.leadingAnchor, bottom: nil, trailing: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: Device.IS_IPHONE ? 140 : 200, height: Device.IS_IPHONE ? 32 : 64)
        favoriteSwitch.setAnchor(top: selectDateButton.bottomAnchor, leading: nil, bottom: nil, trailing: mealImageView.trailingAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: Device.IS_IPHONE ? 50 : 100, height: Device.IS_IPHONE ? 32 : 64)
        favoriteLabel.setAnchor(top: selectDateButton.bottomAnchor, leading: nil, bottom: nil, trailing: favoriteSwitch.leadingAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 0, height: Device.IS_IPHONE ? 32 : 64)
        
        //description field
        mealDescriptionTF.setAnchor(top: descriptionLabel.bottomAnchor,
                                    leading: mealImageView.leadingAnchor,
                                    bottom: nil,
                                    trailing: mealImageView.trailingAnchor,
                                    paddingTop: Device.IS_IPHONE ? 10 : 20,
                                    paddingLeft: 0,
                                    paddingBottom: 0,
                                    paddingRight: 0,
                                    width: 0,
                                    height: Device.IS_IPHONE ? 70 : 100)
        
        mapView.setAnchor(top: mealDescriptionTF.bottomAnchor,
                          leading: mealDescriptionTF.leadingAnchor,
                          bottom: nil,
                          trailing: mealDescriptionTF.trailingAnchor,
                          paddingTop: Device.IS_IPHONE ? 10 : 20,
                          paddingLeft: 0,
                          paddingBottom: 0,
                          paddingRight: 0,
                          width: 0,
                          height: CGFloat(Device.SCREEN_WIDTH * 2 / 3))
        
        saveButton.setAnchor(top: mapView.bottomAnchor,
                             leading: nil,
                             bottom: scrollView.bottomAnchor,
                             trailing: nil,
                             paddingTop: 15,
                             paddingLeft: 0,
                             paddingBottom: 20,
                             paddingRight: 0,
                             width: Device.IS_IPHONE ? 150 : 300,
                             height: Device.IS_IPHONE ? 32 : 64)
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    // Handle keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
}


