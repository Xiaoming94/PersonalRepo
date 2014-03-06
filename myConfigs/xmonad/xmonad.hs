-- Import statements xmonad

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
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
-- import XMonad.Layout.PerWorkspace

-- import XMonad.Layout.ResizableTile

-- Import statements haskell
import System.IO
-- Some copied codes

-- Define the name of all workspace

myWorkspaces = ["main","web","chat","dev","misc","mail","cal"]

-- Defining my Layout configurations. Quite lot of Layouts.

myLayout = simpleFloat ||| ntiled ||| stiled ||| Mirror ntiled ||| Mirror stiled ||| 
  spiraled ||| Full ||| fullScreen
  where
    fullScreen = noBorders (fullscreenFull Full)
    ntiled = Tall nmaster delta ratio
    -- rstiled = ResizableTall nmaster delta ratio
    stiled = spacing 3 $ Tall nmaster delta ratio
    nmaster = 1 -- The number of default master windows
    ratio = 1/2
    gRatio = toRational (2/(1+sqrt(5)::Double)) -- the ratio of the master windows
    delta = 3/100 -- Percentage incrementation

    spiraled = spacing 3 $ spiral gRatio

-- Some personal settings and variables

myTerminal = "urxvt" -- the terminal I use
myModMask = mod4Mask
home = "spacefm"
altMask = mod1Mask

-- Configurations for Xmobar
myBar = "xmobar"

myPP = xmobarPP {
                  ppCurrent = xmobarColor "green" "". wrap "[" "]"
                , ppHidden = xmobarColor "blue" ""
                , ppHiddenNoWindows = xmobarColor "white" ""
                }
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Some Hooks and Window rules

myManagedHooks = composeAll
  [ manageDocks
   ,isFullscreen --> doFullFloat
   ,className=? "Chrome"  --> doShift "web"
   ,className=? "calendar"  --> doShift "cal"
  ]

-- Launching XMonad and some default overrides
startup :: X ()
startup = do
          spawn "~/bin/xmonadautostart"
          spawn "pulseaudio -k"
          setWMName "LG3D"
myConfig = defaultConfig { 
    terminal    = myTerminal
  , modMask     = mod4Mask
  , startupHook = startup
  , manageHook  = myManagedHooks
  , borderWidth = 1
  , layoutHook  = lessBorders OnlyFloat $ avoidStruts $ myLayout
  , workspaces  = myWorkspaces
  , focusedBorderColor = "blue" 
  }`additionalKeys` -- My own keybindings.
    [((controlMask .|. altMask, xK_Left ), prevWS)
    ,((controlMask .|. altMask, xK_Right), nextWS)
    ,((altMask     .|. shiftMask,   xK_w), spawn "chromium")
    ,((myModMask   .|. shiftMask,   xK_d), raiseMaybe (runInTerm "-title calendar" "wyrd")(title =? "calendar"))
    ,((myModMask   .|. controlMask, xK_m), spawn "evolution")
    ,((controlMask,             xK_i),     raiseMaybe (runInTerm "-title hubben" "ssh hubben") (title =? "hubben"))
    ,((myModMask,               xK_p),     spawn "dmenu_run -fn 'inconsolata-10' -nb 'black' -nf 'red'")
    ,((myModMask,               xK_f),     spawn home)
    ,((0,                       xK_Print), spawn "scrot")
    ,((controlMask,             xK_Print), spawn "sleep 0.2; scrot -s")
    ,((myModMask,                   xK_x), spawn "slingshot-launcher")
    ]

main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig
