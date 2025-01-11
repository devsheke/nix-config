/* See LICENSE file for copyright and license details. */

#include <X11/X.h>
/*  --------------------- Appearance --------------------- */

// border pixel of windows.
static const unsigned int borderpx = 2;
// snap pixel.
static const unsigned int snap = 32;
// 0 means no bar.
static const int showbar = 1;
// 0 means bottom bar.
static const int topbar = 1;
// horizontal and vertical padding for statusbar.
static const int horizpadbar = 2;
static const int vertpadbar = 10;

// gap config
// horiz inner gap bw windows
static const unsigned int gappih = 12;
// vert inner gap bw windows
static const unsigned int gappiv = 12;
// horiz outer gap bw windows and screen edge
static const unsigned int gappoh = 12;
// vert outer gap bw windows and screen edge
static const unsigned int gappov = 12;
// 1 means no outer gap when there is only one window
static int smartgaps = 0;

// systray config
// 0: sloppy systray follows selected monitor, >0: pin systray to monitor X.
static const unsigned int systraypinning = 0;
// 0: systray in the right corner, >0: systray on left of status text.
static const unsigned int systrayonleft = 0;
// systray spacing.
static const unsigned int systrayspacing = 2;
// 1: if pinning fails, display systray on the first monitor, False:
// display systray on the last monitor.
static const int systraypinningfailfirst = 1;
static const int showsystray = 1; /* 0 means no systray */

// tag underline config
// horizontal padding between the underline and tag.
static const unsigned int ulinepad = 5;
// thickness / height of the underline.
static const unsigned int ulinestroke = 2;
// how far above the bottom of the bar the line should appear.
static const unsigned int ulinevoffset = 0;
// 1 to show underline on all tags, 0 for just active ones.
static const int ulineall = 0;

// colorful tags
static const unsigned int colorfultag = 1;

// colors and fonts
#include "rose_pine.h"

static const char *fonts[] = {
    "Overpass Nerd Font Propo:style=SemiBold:size=12",
};

static const char *colors[][3] = {
    /*               fg         bg         border   */
    [SchemeNorm] = {text, base, highlight_med},
    [SchemeSel] = {text, overlay, subtle},
    [SchemeTag] = {text, base, highlight_med},
    [SchemeTag1] = {gold, surface, base},
    [SchemeTag2] = {love, surface, base},
    [SchemeTag3] = {foam, surface, base},
    [SchemeTag4] = {iris, surface, base},
    [SchemeTag5] = {pine, surface, base},
    [SchemeTag6] = {text, surface, base},
    [SchemeLayout] = {rose, base, base},
};

/* ========================================================= */

/* ------------------------ Tagging ------------------------ */
static const int tagschemes[] = {SchemeTag1, SchemeTag2, SchemeTag3,
                                 SchemeTag4, SchemeTag5, SchemeTag6};

// tag labels.
static const char *tags[] = {"", "", "", "", "󰃖", ""};
// tag rules.
static const Rule rules[] = {
    /* xprop(1):
     *  WM_CLASS(STRING) = instance, class
     *  WM_NAME(STRING) = title
     */
    /* class      instance    title       tags mask     isfloating   monitor */
    {"Alacritty", NULL, NULL, 1 << 0, 0, -1},
    {".arandr-wrapped", NULL, NULL, 0, 1, -1},
    {".blueman-manager-wrapped", NULL, NULL, 0, 1, -1},
    {"Celluloid", NULL, NULL, 1 << 2, 1, -1},
    {"firefox", "Navigator", NULL, 1 << 1, 0, -1},
    {"KeePassXC", NULL, NULL, 0, 1, -1},
    {"Nvidia-settings", NULL, NULL, 0, 1, -1},
    {"pavucontrol", NULL, NULL, 0, 1, -1},
    {"qBittorrent", NULL, NULL, 0, 1, -1},
    {"Spotify", NULL, NULL, 1 << 2, 1, -1},
    {"Thunar", NULL, NULL, 0, 1, -1},
    {"Thunderbird", NULL, NULL, 1 << 3, 1, -1}};

/* ========================================================= */

/* ------------------------------- Layout(s) ----------------------------- */

#include "vanitygaps.c"

// factor of master area size [0.05..0.95].
static const float mfact = 0.55;
// number of clients in master area.
static const int nmaster = 1;
// 1 means respect size hints in tiled resizals.
static const int resizehints = 1;
// 1 will force focus on the fullscreen window.
static const int lockfullscreen = 1;

static const Layout layouts[] = {
    {"[\\]", dwindle}, {"[]=", tile}, {"[M]", monocle},
    {"><>", NULL},     {NULL, NULL},
};

/* ======================================================================= */

/* --------------------------------- Key definitions
 * ------------------------------ */

#define MODKEY Mod1Mask
#define TAGKEYS(KEY, TAG)                                                      \
  {MODKEY, KEY, view, {.ui = 1 << TAG}},                                       \
      {MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}},               \
      {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}},                        \
      {MODKEY | ControlMask | ShiftMask, KEY, toggletag, {.ui = 1 << TAG}},

// helper for spawning shell commands in the pre dwm-5.0 fashion.
#define SHCMD(cmd)                                                             \
  {                                                                            \
    .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL }                       \
  }

static const Key keys[] = {
    /* modifier                     key        function        argument */
    {MODKEY, XK_space, spawn, SHCMD("rofi -show drun")},
    {MODKEY, XK_c, spawn, SHCMD("rofi -show calc")},
    {MODKEY, XK_Return, spawn, SHCMD("alacritty")},
    {ControlMask, XK_l, spawn, SHCMD("dm-tool lock")},
    {MODKEY, XK_j, focusstack, {.i = +1}},
    {MODKEY, XK_k, focusstack, {.i = -1}},
    {MODKEY, XK_i, incnmaster, {.i = +1}},
    {MODKEY, XK_d, incnmaster, {.i = -1}},
    {MODKEY, XK_h, setmfact, {.f = -0.05}},
    {MODKEY, XK_l, setmfact, {.f = +0.05}},
    {MODKEY | ShiftMask, XK_h, setcfact, {.f = +0.25}},
    {MODKEY | ShiftMask, XK_l, setcfact, {.f = -0.25}},
    {MODKEY | ShiftMask, XK_o, setcfact, {.f = 0.00}},
    {MODKEY, XK_Return, zoom, {0}},
    {MODKEY, XK_Tab, view, {0}},
    {MODKEY, XK_q, killclient, {0}},
    {MODKEY, XK_t, setlayout, {.v = &layouts[0]}},
    {MODKEY, XK_f, setlayout, {.v = &layouts[1]}},
    {MODKEY, XK_m, setlayout, {.v = &layouts[2]}},
    {MODKEY, XK_r, setlayout, {.v = &layouts[3]}},
    {MODKEY | ShiftMask, XK_r, setlayout, {.v = &layouts[4]}},
    {MODKEY | ShiftMask, XK_space, setlayout, {0}},
    {MODKEY | ShiftMask, XK_f, togglefloating, {0}},
    {MODKEY, XK_0, view, {.ui = ~0}},
    {MODKEY | ShiftMask, XK_0, tag, {.ui = ~0}},
    {MODKEY, XK_comma, focusmon, {.i = -1}},
    {MODKEY, XK_period, focusmon, {.i = +1}},
    {MODKEY | ShiftMask, XK_comma, tagmon, {.i = -1}},
    {MODKEY | ShiftMask, XK_period, tagmon, {.i = +1}},
    TAGKEYS(XK_1, 0) TAGKEYS(XK_2, 1) TAGKEYS(XK_3, 2) TAGKEYS(XK_4, 3)
        TAGKEYS(XK_5, 4) TAGKEYS(XK_6, 5){MODKEY | ShiftMask, XK_q, quit, {0}},
};

/* ===========================================================================
 */

/* ------------------------------ Button definitions
 * ---------------------------- */

// click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle,
// ClkClientWin, or ClkRootWin.
static const Button buttons[] = {
    /* click                event mask      button          function argument */
    {ClkLtSymbol, 0, Button1, setlayout, {0}},
    {ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]}},
    {ClkStatusText, 0, Button2, spawn, SHCMD("alacritty")},
    {ClkClientWin, MODKEY, Button1, movemouse, {0}},
    {ClkClientWin, MODKEY, Button2, togglefloating, {0}},
    {ClkClientWin, MODKEY, Button3, resizemouse, {0}},
    {ClkTagBar, 0, Button1, view, {0}},
    {ClkTagBar, 0, Button3, toggleview, {0}},
    {ClkTagBar, MODKEY, Button1, tag, {0}},
    {ClkTagBar, MODKEY, Button3, toggletag, {0}},
};

/* ===========================================================================
 */
