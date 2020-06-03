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
    start_color();
    noecho();
    stdscr.keypad(true);
    init_pair(1, Color.RED, Color.BLACK);
  }

  public void stop() {
    endwin();
  }

  private string[] choices = {
    "Choice 1",
    "Choice 2",
    "Choice 3",
    "Choice 4",
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
    menu.set_options(MenuOption.ONEVALUE | MenuOption.NONCYCLIC);
    menu.set_options_off(MenuOption.NONCYCLIC);
    menu.set_options_on(MenuOption.SHOWDESC);
    window = new Window(10, 40, 4, 4);
    window.keypad(true);
    menu.set_window(window);
    sub_window = window.derwin(6, 38, 3, 1);
    menu.set_sub_window(sub_window);
    menu.set_mark(" * ");

    window.box(0, 0);
    window.attron(COLOR_PAIR(1));
    window.mvprintw(1, 1, "%s", "My menu");
    window.attroff(COLOR_PAIR(1));
    window.mvaddch(2, 0,  Acs.LTEE);
    window.mvhline(2, 1,  Acs.HLINE, 38);
    window.mvaddch(2, 39, Acs.RTEE);
    stdscr.mvprintw(LINES - 2, 0, "F1 to exit");

    menu.post();
    stdscr.noutrefresh();
    window.noutrefresh();

    io.set_callback(() => {
      var c = getch();

      switch (c) {
        case Key.F0+1:
          loop.quit();
          return Source.REMOVE;
        case Key.DOWN:
          menu.driver(MenuRequest.DOWN_ITEM);
          break;
        case Key.UP:
          menu.driver(MenuRequest.UP_ITEM);
          break;
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
