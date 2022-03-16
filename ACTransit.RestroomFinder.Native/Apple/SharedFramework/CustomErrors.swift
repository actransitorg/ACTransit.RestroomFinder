//
//  CustomErrors.swift
//  SharedFramework
//
//  Created by DevTeam on 6/19/18.
//  Copyright © 2018 DevTeam. All rights reserved.
//

import UIKit

public enum CustomErrors: Error {
    case runtimeError(String)
    case parameterError(String)
}
