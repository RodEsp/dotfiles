# Firefox

Install [ArcWTF](https://github.com/KiKaraage/ArcWTF) for an Arc-like experience on Firefox
Just follow the instructions [here](https://github.com/KiKaraage/ArcWTF#applying-the-theme).

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
