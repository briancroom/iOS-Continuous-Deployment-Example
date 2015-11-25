import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var enteredTextLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    private var count = 0

    override func awakeFromNib() {
        title = Strings.homeTitle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        instructionsLabel.text = Strings.instructionsText;
        button.setTitle(Strings.buttonTitle, forState: .Normal)
        updateCount()
        updateEnteredText()
    }

    @IBAction func buttonTapped() {
        count++
        updateCount()
    }

    @IBAction func textFieldChanged() {
        updateEnteredText()
    }

    private func updateCount() {
        countLabel.text = Strings.countLabelText(count: String(count))
    }

    private func updateEnteredText() {
        let text = textField.text ?? ""
        enteredTextLabel.text = Strings.enteredLabelText(text: text, length: String(text.characters.count))
    }
}
