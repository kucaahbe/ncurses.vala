using Curses;
using Posix;

public class Demo {
  public MainLoop loop;
  private TimeoutSource time;

  public Demo() {
    loop = new MainLoop();
    time = new TimeoutSource (2000);
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

  public void activate() {
    printw("SRAKA");
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
