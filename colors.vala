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
    stdscr.keypad(true);
  }

  public void stop() {
    endwin();
  }

  public void activate() {
    for (short c = 0; c < 256; c++) {
      init_pair(c, c, Color.BLACK);
    }

    io.set_callback(() => {
      getch();

      return Source.CONTINUE;
    });
  }

  public void paint() {
    short c = 0;
    for (int y = 0; y < LINES-1; y++) {
      for (int x = 0; x < COLS; x++) {
        if (c > 255) {
          break;
        }
        attron(COLOR_PAIR(c));
        mvprintw(y, x, "+");
        attroff(COLOR_PAIR(c));
        c++;
      }
    }

    mvprintw(LINES-1, 0, "COLORS=%i", COLORS);
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
    app.paint();
    app.redraw();
    app.run();
    app.stop();

    return EXIT_SUCCESS;
  }
}
