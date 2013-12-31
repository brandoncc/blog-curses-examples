require 'curses'

class CursesScreen
  SCREEN_HEIGHT      = 24
  SCREEN_WIDTH       = 80
  HEADER_HEIGHT      = 1
  HEADER_WIDTH       = SCREEN_WIDTH
  MAIN_WINDOW_HEIGHT = SCREEN_HEIGHT - HEADER_HEIGHT
  MAIN_WINDOW_WIDTH  = SCREEN_WIDTH

  def initialize
    Curses.noecho
    Curses.nonl
    Curses.stdscr.keypad(true)
    Curses.raw
    Curses.stdscr.nodelay = 1
    Curses.init_screen
    Curses.start_color
    Curses.init_pair(1, Curses::COLOR_GREEN, Curses::COLOR_BLACK)
    Curses.init_pair(2, Curses::COLOR_BLACK, Curses::COLOR_GREEN)
    Curses.init_pair(3, Curses::COLOR_BLACK, Curses::COLOR_WHITE)
  end

  def build_display
    @header_window = HeaderWindow.new
    @header_window.build_display
    @main_window = MainWindow.new

    @main_window.addch_example
    @main_window.scroll
    @main_window.addstr_example
    @main_window.scroll
    @main_window.push_example
    @main_window.scroll
    @main_window.echo_keys
  end
end

class MainWindow
  def initialize
    @window = Curses::Window.new(24, CursesScreen::MAIN_WINDOW_WIDTH, 1, 0)
    @window.scrollok(true)
    @window.idlok(true)
    @window.color_set(1)
    @window.setpos(CursesScreen::MAIN_WINDOW_HEIGHT - 1, 0)
  end

  def addch_example
    @window.addch('T')
    @window.addch('h')
    @window.addch('i')
    @window.addch('s')
    @window.addch(' ')
    @window.addch('i')
    @window.addch('s')
    @window.addch(' ')
    @window.addch('p')
    @window.addch('a')
    @window.addch('i')
    @window.addch('n')
    @window.addch('f')
    @window.addch('u')
    @window.addch('l')
    @window.addch('!')
  end

  def addstr_example
    @window.addstr('Ahhh, that is better.')
  end

  def push_example
    @window << "Wow, that is even easier!"
  end

  def scroll
    @window.scroll
    @window.setpos(CursesScreen::MAIN_WINDOW_HEIGHT - 1, 0)
  end

  def echo_keys
    self.scroll
    @window << "Press a key to get the ordinal value. Press 'q' to quit."
    until (input = @window.getch) == 'q'
      self.scroll

      @window << "You pressed: #{input}."
      unless input.is_a?(Fixnum)
        @window << " That character has an ordinal value of: #{input.ord}"
      end

      @window.refresh
    end
  end
end

class HeaderWindow
  def initialize
    @window = Curses::Window.new(CursesScreen::HEADER_HEIGHT,
                                 CursesScreen::HEADER_WIDTH, 0, 0)
    @window.color_set(2)
  end

  def build_display
    @window << "Curses example".center(CursesScreen::HEADER_WIDTH)
    @window.refresh
  end
end

@screen = CursesScreen.new
@screen.build_display