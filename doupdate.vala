using Curses;
using Posix;

public class Demo {
  public MainLoop loop;
  private TimeoutSource time;

  public Demo() {
    loop = new MainLoop();
    time = new TimeoutSource (5000);
    time.set_callback (() => { loop.quit(); return false; });
    time.attach(loop.get_context());
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
  public void activate() {
    window1 = new Window(5, 20, 1, 1);
    window1.box(0, 0);
    window1.mvprintw(1, 1, "I am in window 1");
    window1.noutrefresh();

    window2 = new Window(5, 20, 1, 21);
    window2.box(0, 0);
    window2.mvprintw(1, 1, "I am in window 2");
    window2.noutrefresh();
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
