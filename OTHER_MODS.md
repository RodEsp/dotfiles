# Firefox

In `about:config` switch `mousewheel.with_control.action` to `5`.
This makes the zoom action actually zoom (pinch zoom), instead of
increase the size of UI elements (reflow zoom).

# Mac Stuff

### Home & End Keys

Create `~/Library/KeyBindings/DefaultKeyBinding.dict` with the following content:

```
/* https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/EventOverview/TextDefaultsBindings/TextDefaultsBindings.html */

{
  "\UF729"   = "moveToBeginningOfLine:";
  "\UF72B"   = "moveToEndOfLine:";
  "$\UF729"  = moveToBeginningOfLineAndModifySelection:; // shift-home
  "$\UF72B"  = moveToEndOfLineAndModifySelection:; // shift-end
  "^\UF729"  = moveToBeginningOfDocument:; // ctrl-home
  "^\UF72B"  = moveToEndOfDocument:; // ctrl-end
  "^$\UF729" = moveToBeginningOfDocumentAndModifySelection:; // ctrl-shift-home
  "^$\UF72B" = moveToEndOfDocumentAndModifySelection:; // ctrl-shift-end
}
    
```
