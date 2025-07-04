//
//  Data+Ext.swift
//  PersonDetectorSwiftUI
//
//  Created by Yasin Özdemir on 3.07.2025.
//

import Foundation

extension Data{
    func toArray<T>(type: T.Type) -> [T] {
        let elementSize = MemoryLayout<T>.stride
        let count = self.count / elementSize

        return self.withUnsafeBytes { rawBufferPointer in
            let bufferPointer = rawBufferPointer.bindMemory(to: T.self)
            return Array(bufferPointer.prefix(count))
        }
    }
}
