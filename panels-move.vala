using Curses;
using Posix;

public class Demo {
  public MainLoop loop;
  private IOChannel io_channel;
  internal IOSource io;

  struct PanelLocation { int x; int y; }

  public Demo() {
    loop = new MainLoop();

    io_channel = new IOChannel.unix_new(Posix.STDIN_FILENO);
    io = new IOSource(io_channel, IOCondition.IN);
    io.attach(loop.get_context());
  }

  public void start() {
    initscr();
    noecho();
  }

  public void stop() {
    endwin();
  }

  private Window window1;
  private Panel panel1;

  public void activate() {
    PanelLocation panel_location = PanelLocation() { x = 1, y = 1 };
    this.window1 = new Window(5, 20, panel_location.y, panel_location.x);
    panel1 = new Panel(window1);
    this.window1.box(0, 0);
    this.window1.mvprintw(1, 1, "I am in window 1");
    panel1.userptr = (void *)(&panel_location);

    io.set_callback(() => {
      var c = getch();

      panel_location = *((PanelLocation *)panel1.userptr);
      switch (c) {
        case 67: // right
        ++panel_location.x;
        break;
        case 68: // left
        --panel_location.x;
        break;
        case 65: // up
        --panel_location.y;
        break;
        case 66: // down
        ++panel_location.y;
        break;
      }
      panel1.move(panel_location.y, panel_location.x);
      panel1.userptr = (void *)(&panel_location);

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
