require 'curses'

# Setup magic numbers
SCREEN_HEIGHT      = 24
SCREEN_WIDTH       = 80
HEADER_HEIGHT      = 1
HEADER_WIDTH       = SCREEN_WIDTH
MAIN_WINDOW_HEIGHT = SCREEN_HEIGHT - HEADER_HEIGHT
MAIN_WINDOW_WIDTH  = SCREEN_WIDTH

# Documentation is from
# http://ruby-doc.org/stdlib-2.1.0/libdoc/curses/rdoc/Curses.html

# noecho()
# Disables characters typed by the user to be echoed by ::getch as they are
# typed.
Curses.noecho

# nl()
# Enable the underlying display device to translate the return key into newline
# on input, and whether it translates newline into return and line-feed on
# output (in either case, the call ::addch(‘n’) does the equivalent of return
# and line feed on the virtual screen).
#
# Initially, these translations do occur. If you disable them using ::nonl,
# curses will be able to make better use of the line-feed capability, resulting
# in faster cursor motion. Also, curses will then be able to detect the return
# key.
Curses.nonl

# keypad(bool)
# Enables the keypad of the user’s terminal.
#
# If enabled (bool is true), the user can press a function key (such as an arrow
# key) and wgetch returns a single value representing the function key, as in
# KEY_LEFT. If disabled (bool is false), curses does not treat function keys
# specially and the program has to interpret the escape sequences itself. If the
# keypad in the terminal can be turned on (made to transmit) and off (made to
# work locally), turning on this option causes the terminal keypad to be turned
# on when #getch is called.
#
# The default value for keypad is false.
Curses.stdscr.keypad(true)

# raw()
# Put the terminal into raw mode.
#
# Raw mode is similar to ::cbreak mode, in that characters typed are immediately
# passed through to the user program.
#
# The differences are that in raw mode, the interrupt, quit, suspend, and flow
# control characters are all passed through uninterpreted, instead of generating
# a signal. The behavior of the BREAK key depends on other bits in the tty
# driver that are not set by curses.
Curses.raw

# nodelay = bool
# When in no-delay mode #getch is a non-blocking call. If no input is ready
# getch returns ERR.
#
# When in delay mode (bool is false which is the default), #getch blocks until a
# key is pressed.
Curses.stdscr.nodelay = 1

# init_screen()
# Initialize a standard screen
Curses.init_screen

# start_color()
# Initializes the color attributes, for terminals that support it.
#
# This must be called, in order to use color attributes. It is good practice to
# call it just after ::init_screen
Curses.start_color

# init_pair(pair, f, b)
# Changes the definition of a color-pair.
#
# It takes three arguments: the number of the color-pair to be changed pair, the
# foreground color number f, and the background color number b.
#
# If the color-pair was previously initialized, the screen is refreshed and all
# occurrences of that color-pair are changed to the new definition.
Curses.init_pair(1, Curses::COLOR_GREEN, Curses::COLOR_BLACK)
Curses.init_pair(2, Curses::COLOR_BLACK, Curses::COLOR_GREEN)
Curses.init_pair(3, Curses::COLOR_BLACK, Curses::COLOR_WHITE)

# new(height, width, top, left)
# Construct a new Curses::Window with constraints of height lines, width
# columns, begin at top line, and begin left most column.
#
# A new window using full screen is called as
#
# Curses::Window.new(0,0,0,0)
main_window = Curses::Window.new(24, MAIN_WINDOW_WIDTH, 1, 0)

# scrollok(bool)
# Controls what happens when the cursor of a window is moved off the edge of the
# window or scrolling region, either as a result of a newline action on the
# bottom line, or typing the last character of the last line.
#
# If disabled, (bool is false), the cursor is left on the bottom line.
#
# If enabled, (bool is true), the window is scrolled up one line (Note that to
# get the physical scrolling effect on the terminal, it is also necessary to
# call #idlok)
main_window.scrollok(true)

# idlok(bool)
# If bool is true curses considers using the hardware insert/delete line feature
# of terminals so equipped.
#
# If bool is false, disables use of line insertion and deletion. This option
# should be enabled only if the application needs insert/delete line, for
# example, for a screen editor.
#
# It is disabled by default because insert/delete line tends to be visually
# annoying when used in applications where it is not really needed. If
# insert/delete line cannot be used, curses redraws the changed portions of all
# lines.
main_window.idlok(true)


# color_set(col)
# Sets the current color of the given window to the foreground/background
# combination described by the Fixnum col.
main_window.color_set(1)

# setpos(y, x)
# A setter for the position of the cursor in the current window, using
# coordinates x and y
main_window.setpos(MAIN_WINDOW_HEIGHT - 1, 0)

# addch(ch)
# Add a character ch, with attributes, to the window, then advance the cursor.
#
# see also the system manual for curs_addch(3)
main_window.addch('T')
main_window.addch('h')
main_window.addch('i')
main_window.addch('s')
main_window.addch(' ')
main_window.addch('i')
main_window.addch('s')
main_window.addch(' ')
main_window.addch('p')
main_window.addch('a')
main_window.addch('i')
main_window.addch('n')
main_window.addch('f')
main_window.addch('u')
main_window.addch('l')
main_window.addch('!')

# scroll()
# Scrolls the current window up one line.
main_window.scroll

main_window.setpos(MAIN_WINDOW_HEIGHT - 1, 0)

# addstr(str)
# add a string of characters str, to the window and advance cursor
main_window.addstr('Ahhh, that is better.')

main_window.scroll
main_window.setpos(MAIN_WINDOW_HEIGHT - 1, 0)

# <<(str)
# <<
#
# Add String str to the current string.
main_window << "Wow, that is even easier!"

# refresh()
# Refreshes the windows and lines.
main_window.refresh

# Setup header
header_window = Curses::Window.new(HEADER_HEIGHT, HEADER_WIDTH, 0, 0)
header_window.color_set(2)
header_window << "Curses example".center(HEADER_WIDTH)
header_window.refresh

main_window.scroll
main_window.scroll
main_window.setpos(MAIN_WINDOW_HEIGHT - 1, 0)
main_window << "Press a key to get the ordinal value. Press 'q' to quit."

until (input = main_window.getch) == 'q'
  main_window.scroll
  main_window.setpos(MAIN_WINDOW_HEIGHT - 1, 0)

  main_window << "You pressed: #{input}."
  unless input.is_a?(Fixnum)
    main_window << " That character has an ordinal value of: #{input.ord}"
  end

  main_window.refresh
end

