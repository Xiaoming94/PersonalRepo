-- Import statements xmonad

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Actions.CycleWS
import XMonad.Actions.WindowGo
import XMonad.Layout
import XMonad.Layout.Spacing
import XMonad.Layout.SimpleFloat
import XMonad.Layout.SimpleDecoration
import XMonad.Layout.Spiral
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Layout.Magnifier as Mag
import XMonad.Layout.Circle
-- import XMonad.Layout.PerWorkspace

-- import XMonad.Layout.ResizableTile

-- Import statements haskell
import System.IO
-- Some copied codes

-- Define the name of all workspace

myWorkspaces = ["1:main","2:web","3:chat","4:dev","5:music","6:steam","7:misc"]

-- Defining my Layout configurations. Quite lot of Layouts.

myLayout = ntiled ||| stiled ||| Mirror ntiled ||| Mirror stiled ||| Mag.magnifier (Mirror stiled) |||
  spiraled ||| Full ||| fullScreen
  where
    fullScreen = noBorders (fullscreenFull Full)
    ntiled = Tall nmaster delta ratio
    --magnified = Mag.magnifier (stiled)
    -- rstiled = ResizableTall nmaster delta ratio
    stiled = spacing space $ Tall nmaster delta ratio
    nmaster = 1 -- The number of default master windows
    ratio = 1/2
    gRatio = toRational (2/(1+sqrt(5)::Double)) -- the ratio of the master windows
    delta = 3/100 -- Percentage incrementation

    space = 7
    spiraled = spacing space $ spiral gRatio

-- Some personal settings and variables

myTerminal = "urxvt" -- the terminal I use
myModMask = mod4Mask
home = myTerminal ++ " -e ranger"
altMask = mod1Mask
web = "chromium-touch"

-- Configurations for Xmobar
myBar = "xmobar"

myPP = xmobarPP {
                  ppCurrent = xmobarColor "green" "". wrap "[" "]"
                , ppHidden = xmobarColor "blue" ""
                , ppHiddenNoWindows = xmobarColor "white" ""
                , ppLayout = xmobarColor "purple" ""
                , ppUrgent = xmobarColor "red" ""
                , ppTitle  = xmobarColor "#09cdda" ""
                }
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Some Hooks and Window rules

myManagedHooks = composeAll
  [isFullscreen --> doFullFloat
   ,isDialog --> doCenterFloat
   ,className =? "Google-chrome-stable"  --> doShift "2:web"
   ,className =? "Chromium"  --> doShift "2:web"
   ,className =? "Pidgin"   --> doShift "3:chat"
   ,className =? "i3lock"   --> doFullFloat
   ,className =? "Gimp"	   --> doFloat
   ,className =? "Skype"    --> doShift "3:chat"
   ,className =? "Spotify"  --> doShift "5:music"
   ,className =? "Florence" --> doIgnore
   ,className =? "Steam"    --> doShift "6:steam"
   ,title =? "Slingshot"    --> doFullFloat
   ,title =? "hubben"    --> doShift "3:chat"
  ]

-- Launching XMonad and some default overrides
startup :: X ()
startup = do
          -- spawn "pulseaudio -k"
          setWMName "LG3D"
          spawn "~/bin/myscripts/xmonadautostart"

myConfig = ewmh defaultConfig { 
    terminal    = myTerminal
  , modMask     = mod4Mask
  , startupHook = setWMName "LG3D" <+> startup
  , manageHook  = manageDocks <+> myManagedHooks <+> manageHook defaultConfig
  , borderWidth = 1
  , handleEventHook = handleEventHook defaultConfig <+> XMonad.Hooks.EwmhDesktops.fullscreenEventHook
  , layoutHook  = lessBorders OnlyFloat $ avoidStruts $ myLayout
  , workspaces  = myWorkspaces
  , focusedBorderColor = "#230251"
  , normalBorderColor = "#111111"
  }`additionalKeys` -- My own keybindings.
    [((controlMask .|. altMask, xK_Left ), prevWS)
    ,((controlMask .|. altMask, xK_Right), nextWS)
    ,((altMask     .|. shiftMask,   xK_w), raiseMaybe (spawn web )(className =? "Google-chrome-stable"))
    ,((myModMask   .|. shiftMask,   xK_d), raiseMaybe (runInTerm "EDITOR=vim" "wyrd")(title =? "wyrd"))
    ,((myModMask   .|. controlMask, xK_m), spawn "geary")
    ,((controlMask,             xK_i),     raiseMaybe (runInTerm "-title hubben" "ssh hubben") (title =? "hubben"))
    ,((myModMask,               xK_p),     spawn "dmenu_run -fn 'inconsolata-10' -nb 'black' -nf 'red'")
    ,((myModMask,               xK_f),     spawn home)
    ,((0,                       xK_Print), spawn "scrot ~/Pictures/%Y-%m-%d-%T-screenshot.png")
    ,((controlMask,             xK_Print), spawn "sleep 0.2; scrot -s")
    ,((myModMask,                   xK_x), spawn "slingshot-launcher")
    ,((myModMask   .|. controlMask, xK_h), sendMessage Mag.MagnifyMore)
    ,((myModMask   .|. controlMask, xK_l), sendMessage Mag.MagnifyLess)
    ,((myModMask   .|. controlMask, xK_t), spawn "togglecom compton")
    ,((myModMask, xK_s), spawn "togglecom conky")

    -- For Sound Control
--    ,((0,			0x1008ff11),		   spawn "amixer set Master 5%-")
--    ,((0,			0x1008ff13),		   spawn "amixer set Master 5%+")
--    ,((0,			0x1008ff12),		   spawn "amixer set Master toggle")
    ]

main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig
