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
    initscr();
    noecho();
    stdscr.keypad(true);
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
    menu.post();
    refresh();

    io.set_callback(() => {
      var c = getch();

      switch (c) {
        case Key.DOWN:
          menu.driver(MenuRequest.DOWN_ITEM);
          break;
        case Key.UP:
          menu.driver(MenuRequest.UP_ITEM);
          break;
        default:
          break;
      }

      refresh();

      return Source.CONTINUE;
    });
  }

  public void run() {
    loop.run();
  }

  public void redraw() {
    refresh();
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
