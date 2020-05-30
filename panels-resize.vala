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
    unowned var stdscr = initscr();
    noecho();
    stdscr.keypad(true);
  }

  public void stop() {
    endwin();
  }

  private Window window1;
  private Panel panel1;
  private PanelSize panel_size;

  public void activate() {
    panel_size = PanelSize() { width = 20, height = 5 };
    this.window1 = new Window(panel_size.height, panel_size.width, 1, 1);
    panel1 = new Panel(window1);
    this.window1.box(0, 0);
    this.window1.mvprintw(1, 1, "I am in window 1");
    panel1.userptr = (void *)(&panel_size);

    io.set_callback(() => {
      var c = getch();

      panel_size = *((PanelSize *)panel1.userptr);
      switch (c) {
        case Key.RIGHT: // right
        ++panel_size.width;
        ++panel_size.height;
        break;
        case Key.LEFT: // left
        --panel_size.width;
        --panel_size.height;
        break;
      }

      Window *t = new Window(panel_size.height, panel_size.width, 1, 1);
      panel1.replace(t);
      t->box(0, 0);
      window1.mvprintw(1, 1, "new");
      window1 = (owned)t; // here happens call to delwin (for previous window1 instance), which must be after Panel.replace call

      panel1.userptr = (void *)(&panel_size);

      refresh(); // this is important, clears artifacts from removed windows
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
