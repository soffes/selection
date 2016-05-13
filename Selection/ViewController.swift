//
//  ViewController.swift
//  Selection
//
//  Created by Sam Soffes on 11/12/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let textView: UITextView = {
		let view = UITextView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16)
		view.alwaysBounceVertical = true

		let fontSize: CGFloat = 16
		var fontDescriptor = UIFontDescriptor(fontAttributes: [
			UIFontDescriptorNameAttribute: "Menlo",
			UIFontDescriptorCascadeListAttribute: [
				UIFont.systemFontOfSize(fontSize).fontDescriptor()
			]
		])

		view.font = UIFont(descriptor: fontDescriptor, size: fontSize)

		return view
	}()

	let selectionBarButtonItem = UIBarButtonItem()
	let lineBarButtonItem = UIBarButtonItem()

	override func viewDidLoad() {
		super.viewDidLoad()

		automaticallyAdjustsScrollViewInsets = false
		textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
		textView.scrollIndicatorInsets = textView.contentInset

		navigationController?.navigationBarHidden = true
		navigationController?.toolbarHidden = false

		view.backgroundColor = .whiteColor()

		lineBarButtonItem.target = self
		lineBarButtonItem.action = #selector(line)

		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)

		toolbarItems = [
			selectionBarButtonItem,
			flexibleSpace,
			lineBarButtonItem,
			flexibleSpace,
			UIBarButtonItem(title: "\\n", style: .Plain, target: self, action: #selector(replaceEscapes))
		]

		textView.delegate = self
		view.addSubview(textView)

		textView.text = UIPasteboard.generalPasteboard().string
		replaceEscapes(nil)

		NSLayoutConstraint.activateConstraints([
			textView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
			textView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
			textView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 20),
			textView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
		])
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		textView.becomeFirstResponder()
	}

	@objc private func replaceEscapes(sender: AnyObject?) {
		textView.text = textView.text.stringByReplacingOccurrencesOfString("\\n", withString: "\n")
			.stringByReplacingOccurrencesOfString("\\\"", withString: "\"")
			.stringByReplacingOccurrencesOfString("\\'", withString: "'")
	}

	func line(sender: AnyObject?) {
		let text = textView.text as NSString
		textView.selectedRange = text.lineRangeForRange(textView.selectedRange)
	}
}


extension ViewController: UITextViewDelegate {
	func textViewDidChangeSelection(textView: UITextView) {
		selectionBarButtonItem.title = "\(textView.selectedRange)"

		let text = textView.text as NSString
		lineBarButtonItem.title =  "\(text.lineRangeForRange(textView.selectedRange))"
	}
}
