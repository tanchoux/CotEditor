//
//  NSSplitViewController+Autosave.swift
//
//  CotEditor
//  https://coteditor.com
//
//  Created by 1024jp on 2018-08-23.
//
//  ---------------------------------------------------------------------------
//
//  © 2018-2020 1024jp
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import AppKit

extension NSSplitViewController {
    
    /// Restore divider positions based on the autosaved data.
    func restoreAutosavePositions() {
        
        assert(self.splitView.isVertical)
        
        guard
            let subviewStates = self.splitView.autosavingSubviewStates,
            subviewStates.count == self.splitViewItems.count
            else { return }
        
        for (item, state) in zip(self.splitViewItems, subviewStates) {
            if !state.isCollapsed, !state.frame.isEmpty {
                item.viewController.view.frame.size = state.frame.size
            }
            item.isCollapsed = state.isCollapsed
        }
    }
    
}



private extension NSSplitView {
    
     struct AutosavingSubviewState {
        
        var frame: NSRect
        var isCollapsed: Bool
    }
    
    
    var autosavingSubviewStates: [AutosavingSubviewState]? {
        
        guard
            let autosaveName = self.autosaveName,
            let subviewFrames = UserDefaults.standard.stringArray(forKey: "NSSplitView Subview Frames " + autosaveName)
            else { return nil }
        
        return subviewFrames.map { string in
            let components = string.components(separatedBy: ", ")
            let isCollapsed = (components[safe: 4] as NSString?)?.boolValue ?? false
            
            assert(components.count == 6)
            assert(components[4] == "YES" || components[4] == "NO")
            assert(components[5] == "YES" || components[5] == "NO")
            
            return AutosavingSubviewState(frame: NSRectFromString(string), isCollapsed: isCollapsed)
        }
    }
    
}
