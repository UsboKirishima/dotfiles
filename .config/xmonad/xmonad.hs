-------------------------------
-- XMonad Configuration File --
-------------------------------

import XMonad
import Data.Monoid
import System.Exit

import XMonad.Util.SpawnOnce        -- Run programs
import XMonad.Util.Run              -- Run programs
import XMonad.Util.Loggers          -- Loggers to use with ppExtras
import XMonad.Util.ClickableWorkspaces  -- Function that auto adds clickable ws to PPs
import XMonad.Util.EZConfig         -- More readable keybinding format

import XMonad.Hooks.ManageDocks     -- Managing Docks/Panels/Bars
import XMonad.Hooks.StatusBar       -- Creating and sending statuses to the bars
import XMonad.Hooks.StatusBar.PP    -- StatusBar's Pretty Printer
import XMonad.Hooks.EwmhDesktops    -- Implements the EWMH X11 standard

import XMonad.Layout.Spacing        -- Interior Gaps
import XMonad.Layout.Renamed        -- Rename Layouts
import XMonad.Layout.NoBorders      -- Disable borders for some layouts
import XMonad.Layout.Gaps           -- Setup gaps

import XMonad.Actions.UpdatePointer -- Function for moving the mouse with the window focus

import qualified XMonad.StackSet as W
import qualified Data.Map        as M


-------------------------------------------------------------------------------
-- Basic Settings
-------------------------------------------------------------------------------
myModMask       = mod4Mask          -- WM Modifier key. mod4=Super; mod1=Alt

myTerminal      = "alacritty"       -- terminal
myPrompt        = "rofi -show run"       -- prompt
myBrowser       = ""                -- web browser
myFileManager   = "thunar"          -- file manager

myBorderWidth   = 2
myNormalBorderColor  = "#6e738d"
myFocusedBorderColor = "#ea76cb"

myWorkspaces    = ["1","2","3","4","5","6","7","8"]


--------------------------------------------------------------------------------
-- Layouts
-------------------------------------------------------------------------------
-- Window Gaps Settings      -- n  s  e  w
mySpacing = spacingRaw False                -- disable spacing for single window
                       (Border  5 5 40 30) -- screen edge gap size
                       True                 -- enable screen edge gaps
                       (Border  5  5  5 10) -- window gap size
                       True                 -- enable window gaps

-- Layout Definitions
masterstack_v = renamed [Replace "Master Stack"]
              -- $ avoidStruts
              -- $ gaps [(L,80), (R,80)]
              $ mySpacing
              $ Tall 1 (4/100) (3/5)  -- # of master windows; resize increment; master window size
monocle       = renamed [Replace "Monocle"]
              $ avoidStruts
              $ noBorders
              $ Full
fullscreen    = renamed [Replace "Fullscreen"]
              $ noBorders
              $ Full

-- Main layout definition
--myLayout = (masterstack_v ||| monocle ||| fullscreen)
myLayout = avoidStruts(tiled ||| Mirror tiled ||| Full)
	where
		-- default tiling algorithm partitions the screen into two panes
		tiled   = Tall nmaster delta ratio

		-- The default number of windows in the master pane
		nmaster = 1

		-- Default proportion of screen occupied by master pane
		ratio   = 1/2

		-- Percent of screen to increment by when resizing panes
		delta   = 3/100

------------------------------------------------------------------------------
-- Window Hooks
-------------------------------------------------------------------------------
-- StartupHook: Stuff to run when the WM starts up.
myStartupHook = do
    --spawnOnce "lxsession &"  -- Polkit provider
    spawnOnce "~/.screenlayout/layout.sh"  -- set monitor layout w xrandr
    spawnOnce "polybar bar1"
    spawnOnce "polybar bar2"
    spawnOnce "polybar bar3"
    spawnOnce "nitrogen --restore &"  -- restore the wallpaper
    spawnOnce "feh --no-fehbg --bg-scale $HOME/Pictures/bg.jpg"
    spawnOnce "picom --use-ewmh-active-win --experimental-backends --config /home/cooro/.config/picom/picom.conf &"  -- start the compositor
    --spawnOnce ("killall trayer ; trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0x1E1E28 --height 19 --widthtype request --margin 7 --distance 1 --monitor 1 &")  -- system tray
    spawnOnce "dunst &"  -- notification daemon
    spawnOnce "nm-applet &"  -- network manager applet
    --spawnOnce "volumeicon &"  -- volume icon
    spawnOnce "nextcloud &"  -- nextcloud client
    spawnOnce "/usr/bin/emacs --daemon"

-- ManageHook: Stuff to run when a new window is made. Use to create window rules, 
-- such as sending certain apps to a specific workspace or setting a certain app 
-- floating mode when it's spawned.
myManageHook = composeAll
    [ resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , className =? "gimp"           --> doShift "doc"
    , className =? "discord"        --> doShift "irc"
    , className =? "steam"          --> doShift "gfx"
    , className =? "lutris"         --> doShift "gfx"
    , className =? "minecraft"      --> doShift "gfx"
    ]

-- LogHook: Stuff to run at each window manager state change.
--myLogHook = updatePointer (0.95, 0.05) (0, 0)  -- updatePointer: moves the mouse when window focus changes
myLogHook = mempty

-- EventHook: Function that should be used to handle X Events. Set this to `mempty` 
-- for the default handler.
myEventHook = mempty


-------------------------------------------------------------------------------
-- Key Bindings
-------------------------------------------------------------------------------
myKeys :: [(String, X())]
myKeys = 
    -- ^SECTION^ XMonad
    [ ("M-S-r", spawn "xmonad --recompile; xmonad --restart")   -- Recompile and restart XMonad
    , ("M-S-C-e", io (exitWith ExitSuccess))                    -- Exit XMonad
    , ("M-n", refresh)                                          -- Resize windows to the correct size

    -- ^SECTION^ Applications
    , ("M-<Return>", spawn $ myTerminal)    -- Launch a Terminal
    , ("M-r", spawn "rofi -show run")            -- Launch a Prompt
    , ("<XF86AudioRaiseVolume>", spawn "pamixer -i 5")
    , ("<XF86AudioLowerVolume>", spawn "pamixer -d 5")
    , ("<XF86AudioMute>", spawn "pamixer -t")
    , ("M-P", spawn "flameshot --gui")

    -- ^SECTION^ Layout Control
    , ("M-w", sendMessage $ JumpToLayout "Master Stack")            -- Switch to Master Stack layout
    , ("M-e", sendMessage $ JumpToLayout "Monocle")                 -- Switch to Monocle layout

    -- ^SECTION^ Window Control
    , ("M-S-q", kill)                           -- Close the focused window
    , ("M-q", withFocused $ windows . W.sink)   -- Tile a floating window
    
    , ("M-j", windows W.focusDown)              -- Move focus to the next window 
    , ("M-k", windows W.focusUp)                -- Move focus to the previous window
    , ("M-<Tab>", windows W.focusMaster)        -- Move focus to the master window

    , ("M-S-j", windows W.swapDown)             -- Move focused window down in the stack
    , ("M-S-k", windows W.swapUp)               -- Move focused window up in the stack
    , ("M-S-<Tab>", windows W.swapMaster)       -- Swap focused window and the master window

    -- ^SECTION^ Master Settings
    , ("M-h", sendMessage Shrink)                 -- Shrink the master area
    , ("M-l", sendMessage Expand)                 -- Grow the master area
    , ("M-S-h", sendMessage (IncMasterN (-1)))    -- Decrement the number of windows in master area
    , ("M-S-l", sendMessage (IncMasterN 1))       -- Increment the number of windows in master area
    ]
    ++
    -- Still not sure exactly how this works, but the string on the second line 
    -- represents all the keys for accessing each workspace in order, and the second 
    -- string on the third line represents the modifier to add to do client movement 
    -- instead of switching to a workspace.
    -- ^SECTION^ Workspaces
    [(("M-"++mask++[key]), action tag)
        | (tag, key) <- zip myWorkspaces "asdfuiop"
        , (mask, action) <- [("", windows . W.greedyView), ("S-", windows . W.shift)]]


-------------------------------------------------------------------------------
-- Mouse Bindings
-------------------------------------------------------------------------------
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]


-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------
main = xmonad $ ewmhFullscreen . ewmh . docks
     $ def { terminal           = myTerminal
           , focusFollowsMouse  = True
           , clickJustFocuses   = False
           , borderWidth        = myBorderWidth
           , modMask            = myModMask
           , workspaces         = myWorkspaces
           , normalBorderColor  = myNormalBorderColor
           , focusedBorderColor = myFocusedBorderColor
           , mouseBindings      = myMouseBindings
           --, layoutHook         = myLayout
           , layoutHook         = gaps [(L,0), (R,0), (U,0), (D,0)] $ spacingRaw False (Border 10 10 10 10) True (Border 10 10 10 10) True $ myLayout
           , manageHook         = myManageHook
           , handleEventHook    = myEventHook
           , logHook            = myLogHook
           , startupHook        = myStartupHook
           } `additionalKeysP` myKeys  -- this is the way EZConfig incorporates the keybindings instead of the `keys` variable

