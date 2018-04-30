//
//  TextViewController.swift
//  Selection
//
//  Created by Sam Soffes on 11/12/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import UIKit

final class TextViewController: UIViewController {

	// MARK: - Properties

	let textView: UITextView = {
		let view = UITextView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16)
		view.alwaysBounceVertical = true

		let fontSize: CGFloat = 16
		var fontDescriptor = UIFontDescriptor(fontAttributes: [
			UIFontDescriptor.AttributeName.name: "Menlo",
			UIFontDescriptor.AttributeName.cascadeList: [
				UIFont.systemFont(ofSize: fontSize).fontDescriptor
			]
		])

		view.font = UIFont(descriptor: fontDescriptor, size: fontSize)

		return view
	}()

	let selectionBarButtonItem = UIBarButtonItem()
	let lineBarButtonItem = UIBarButtonItem()


	// MARK: - UIViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		automaticallyAdjustsScrollViewInsets = false
		textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
		textView.scrollIndicatorInsets = textView.contentInset

		navigationController?.isNavigationBarHidden = true
		navigationController?.isToolbarHidden = false

		view.backgroundColor = .white

		lineBarButtonItem.target = self
		lineBarButtonItem.action = #selector(line)

		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

		toolbarItems = [
			selectionBarButtonItem,
			flexibleSpace,
			lineBarButtonItem,
			flexibleSpace,
			UIBarButtonItem(title: "\\n", style: .plain, target: self, action: #selector(replaceEscapes))
		]

		textView.delegate = self
		view.addSubview(textView)

		textView.text = UIPasteboard.general.string
		replaceEscapes(nil)

		NSLayoutConstraint.activate([
			textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
			textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		textView.becomeFirstResponder()
	}


	// MARK: - Actions

	@objc fileprivate func replaceEscapes(_ sender: AnyObject?) {
		textView.text = textView.text.replacingOccurrences(of: "\\n", with: "\n")
			.replacingOccurrences(of: "\\\"", with: "\"")
			.replacingOccurrences(of: "\\'", with: "'")
	}

	@objc func line(_ sender: AnyObject?) {
		let text = textView.text as NSString
		textView.selectedRange = text.lineRange(for: textView.selectedRange)
	}
}


extension TextViewController: UITextViewDelegate {
	func textViewDidChangeSelection(_ textView: UITextView) {
		selectionBarButtonItem.title = "\(textView.selectedRange)"

		let text = textView.text as NSString
		lineBarButtonItem.title =  "\(text.lineRange(for: textView.selectedRange))"
	}
}
