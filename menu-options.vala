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
    init_pair(2, Color.GREEN, Color.BLACK);
    init_pair(3, Color.MAGENTA, Color.BLACK);
  }

  public void stop() {
    menu.unpost();
    endwin();
  }

  private string[] choices = {
    "Choice 1",
    "Choice 2",
    "Choice 3",
    "Choice 4",
    "Choice 5",
    "Choice 6",
    "Choice 7",
    "Exit",
  };
  private Menu menu;
  private Window window;
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

    menu_items[3].opts_off(ItemOption.SELECTABLE);
    menu_items[6].opts_off(ItemOption.SELECTABLE);

    menu = new Menu(menu_items);

    // Set fore ground and back ground of the menu
    menu.set_fore(COLOR_PAIR(1) | Attribute.REVERSE);
    menu.set_back(COLOR_PAIR(2));
    menu.set_grey(COLOR_PAIR(3));

    // Post the menu
    stdscr.mvprintw(LINES - 3, 0, "Press <ENTER> to see the option selected");
    stdscr.mvprintw(LINES - 2, 0, "Up and Down arrow keys to naviage (F1 to Exit)");

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
        case 10: // Enter
                        stdscr.move(20, 0);
                        stdscr.clrtoeol();
                        stdscr.mvprintw(20, 0, "Item selected is : %s",
                                        menu.current_item.name);
                        menu.pos_cursor();
                        break;
        default:
          break;
      }

      stdscr.noutrefresh();
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
