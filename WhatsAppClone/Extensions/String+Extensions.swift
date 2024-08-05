//
//  String+Extensions.swift
//  WhatsAppClone
//
//  Created by enesozmus on 5.08.2024.
//

import Foundation

extension String {
    var isEmptyOrWhiteSpace: Bool { return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
}
