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
  }

  public void stop() {
    endwin();
  }

  private Window window1;
  private Window window2;

  private Panel panel1;
  private Panel panel2;
  public void activate() {
    this.window1 = new Window(5, 20, 1, 1);
    panel1 = new Panel(window1);
    this.window1.box(0, 0);
    this.window1.mvprintw(1, 1, "I am in window 1");
    //this.window1.noutrefresh();

    this.window2 = new Window(5, 20, 2, 19);
    panel2 = new Panel(window2);
    this.window2.box(0, 0);
    this.window2.mvprintw(1, 1, "I am in window 2");
    //this.window2.noutrefresh();

    panel1.userptr = panel2;
    panel2.userptr = panel1;

    unowned Panel top_panel = panel2;

    io.set_callback(() => {
      var c = getch();

      if (c == Key.F0) {
        loop.quit();
      } else if (c == 's') {
        top_panel.show();
        Panel.update_panels();
        doupdate();
      } else if (c == 'h') {
        top_panel.hide();
        Panel.update_panels();
        doupdate();
      } else {
        top_panel = (Panel) top_panel.userptr;
        top_panel.top();
        Panel.update_panels();
        doupdate();
      }

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
