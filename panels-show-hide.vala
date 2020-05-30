using Curses;
using Posix;

public class Demo {
  public MainLoop loop;
  private IOChannel io_channel;
  internal IOSource io;

  struct PanelSize { int width; int height; }

  public Demo() {
    loop = new MainLoop();

    io_channel = new IOChannel.unix_new(Posix.STDIN_FILENO);
    io = new IOSource(io_channel, IOCondition.IN);
    io.attach(loop.get_context());
  }

  public void start() {
    unowned Window stdscr = initscr();
    noecho();
    stdscr.keypad(true);
  }

  public void stop() {
    endwin();
  }

  private Window window1;
  private Panel panel1;

  public void activate() {
    this.window1 = new Window(20, 20, 1, 1);
    panel1 = new Panel(window1);
    this.window1.box(0, 0);
    this.window1.mvprintw(1, 1, "I am panel");

    io.set_callback(() => {
      getch();

      if (panel1.hidden() == 1) {
        panel1.show();
      } else {
        panel1.hide();
      }

      Panel.update_panels();
      doupdate();

      return Source.CONTINUE;
    });
  }

  public void run() {
    loop.run();
  }

  public void redraw() {
    Panel.update_panels();
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
