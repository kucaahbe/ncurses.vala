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
    if (has_colors() == false) {
      endwin();
      printf("Your terminal does not support color\n");
      exit(EXIT_FAILURE);
    }
    start_color();
    noecho();

    init_pair(1, Color.BLUE, Color.BLACK);
    init_pair(2, Color.WHITE, Color.BLACK);
  }

  public void stop() {
    endwin();
  }

  private Window win1;
  private Window win2;
  private unowned Window active_win;

  public void activate() {
    win1 = new Window(3, 3);
    win2 = new Window(3, 3+10+3);
    active_win = win1;
    active_win.make_active();
    win1.refresh();
    win2.refresh();

    io.set_callback(() => {
      var c = active_win.getch();

      switch (c) {
        case Key.LEFT:
          active_win.make_inactive();
          active_win = win1;
          active_win.make_active();
          break;
        case Key.RIGHT:
          active_win.make_inactive();
          active_win = win2;
          active_win.make_active();
          break;
        default:
          active_win.send_input(c);
          break;
      }

      win1.refresh();
      win2.refresh();
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

private class Window {
  public Window(int y, int x) {
    this.window = new Curses.Window(HEIGHT, WIDTH, y, x);
    window.box(0,0);
    window.keypad(true);
    window.move(1,1);
  }

  public void refresh() {
    window.noutrefresh();
  }

  public void send_input(int c) {
    int y = 0;
    int x = 0;
    window.getyx(y, x); // getyx is a macro

    if (x == 0) { x++; }
    if (y == 0) { y++; }
    if (x == WIDTH-1) { x=1; y++; }
    if (y == HEIGHT-1) { y--; }

    window.move(y, x);
    window.addch(c);
  }

  public int getch() {
    return window.getch();
  }

  public void make_active() {
    window.attron(COLOR_PAIR(1));
    window.box(0,0);
    window.attroff(COLOR_PAIR(1));
  }

  public void make_inactive() {
    window.attron(COLOR_PAIR(2));
    window.box(0,0);
    window.attroff(COLOR_PAIR(2));
  }

  const int WIDTH = 10;
  const int HEIGHT = 10;
  private Curses.Window window;
}
