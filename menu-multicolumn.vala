using Curses;
using Posix;

public class Demo {
  public MainLoop loop;
  private IOChannel io_channel;
  internal IOSource io;

  public Demo() {
    loop = new MainLoop();

    io_channel = new IOChannel.unix_new(Posix.STDIN_FILENO);
    io = new IOSource(io_channel, IOCondition.IN);
    io.attach(loop.get_context());
  }

  public void start() {
    Intl.setlocale(); // setlocale(LC_ALL, "")
    initscr();
    curs_set(0); // hide cursor
    noecho();
    cbreak();
    start_color();
    stdscr.keypad(true);
    init_pair(1, Color.RED, Color.BLACK);
    init_pair(2, Color.CYAN, Color.BLACK);
  }

  public void stop() {
    menu.unpost();
    endwin();
  }

  private string[] choices = {
    "Choice 1", "Choice 2", "Choice 3", "Choice 4", "Choice 5",
    "Choice 6", "Choice 7", "Choice 8", "Choice 9", "Choice 10",
    "Choice 11", "Choice 12", "Choice 13", "Choice 14", "Choice 15",
    "Choice 16", "Choice 17", "Choice 18", "Choice 19", "Choice 20",
    "Exit",
  };
  private Menu menu;
  private Window window;
  private Window sub_window;
  private MenuItem[] menu_items = {};

  public void activate() {
    // passing unowned choice here is critical,
    // as vala will free(choice) makig menu render
    // blank items
    foreach (unowned string choice in choices) {
      menu_items += new MenuItem(choice, choice);
    }
    // no need to add last null item to menu items (as new Menu() requires)
    // in vala arrays are null-terminated by default

    menu = new Menu(menu_items);
    // Set menu option not to show the description
    menu.set_options_off(MenuOption.SHOWDESC);

    // Create the window to be associated with the menu
    window = new Window(10, 70, 4, 4);
    window.keypad(true);
     
    // Set main window and sub window
    menu.set_window(window);
    sub_window = window.derwin(6, 68, 3, 1);
    menu.set_sub_window(sub_window);
    menu.set_format(5, 3);
    menu.set_mark(" * ");

    // Print a border around the main window and print a title
    window.box(0, 0);

    stdscr.attron(COLOR_PAIR(2));
    stdscr.mvprintw(LINES - 3, 0, "Use PageUp(fn+Up on mac) and PageDown(fn+Down on mac) to scroll");
    stdscr.mvprintw(LINES - 2, 0, "Use Arrow Keys to navigate (F1 to Exit)");
    stdscr.attroff(COLOR_PAIR(2));

    menu.post();
    stdscr.noutrefresh();
    window.noutrefresh();

    io.set_callback(() => {
      var c = getch();

      switch (c) {
        case Key.F0+1:
          loop.quit();
          return Source.REMOVE;
        case Key.DOWN:  menu.driver(MenuRequest.DOWN_ITEM);  break;
        case Key.UP:    menu.driver(MenuRequest.UP_ITEM);    break;
        case Key.LEFT:  menu.driver(MenuRequest.LEFT_ITEM);  break;
        case Key.RIGHT: menu.driver(MenuRequest.RIGHT_ITEM); break;
        case Key.NPAGE: menu.driver(MenuRequest.SCR_DPAGE);  break;
        case Key.PPAGE: menu.driver(MenuRequest.SCR_UPAGE);  break;
        default:
          break;
      }

      window.noutrefresh();
      redraw();

      return Source.CONTINUE;
    });
  }

  public void run() {
    loop.run();
  }

  public void redraw() {
    doupdate();
  }

  static int main(string[] args) {
    var app = new Demo();

    app.start();
    app.activate();
    app.redraw();
    app.run();
    app.stop();

    return EXIT_SUCCESS;
  }
}
