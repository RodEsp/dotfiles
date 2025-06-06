# Firefox

Install [ArcWTF](https://github.com/KiKaraage/ArcWTF) for an Arc-like experience on Firefox
 
### Hide the top tab bar

1. Find your profile folder (hence referred to as `${PROFILE}`): go to `about:support` and look at the line that says `Profile Directory`.
1. Toggle the [relevant `about:config`](https://github.com/FirefoxCSS-Store/FirefoxCSS-Store.github.io/blob/main/README.md#generic-installation) flags.
1. Close Firefox.
1. Put this in `${PROFILE}/chrome/userChrome.css` (create the file if it doesn't already exist):
```css
#TabsToolbar
{
    visibility: collapse;
}
```
5. Start up Firefox again. 

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
