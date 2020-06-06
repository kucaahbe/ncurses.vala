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

  [CCode (has_target = false)]
  private delegate void MenuItemCallback(string name);

  public void activate() {
    MenuItem item;
    MenuItemCallback cb = ((name) => {
      stdscr.move(20, 0);
      stdscr.clrtoeol();
      stdscr.mvprintw(20, 0, "Item selected is : %s", name);
    });

    foreach (unowned string choice in choices) {
      item = new MenuItem(choice, choice);
      item.set_userptr((void *)cb);
      menu_items += (owned) item;
    }

    menu = new Menu(menu_items);
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
                        unowned MenuItem current_itm = menu.current_item;
                        MenuItemCallback p;

                        p = (MenuItemCallback)current_itm.userptr;
                        p(current_itm.name);

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
