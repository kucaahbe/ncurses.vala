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
    this.window1 = new Window(5, 20, 1, 1);
    this.window1.box(0, 0);
    this.window1.mvprintw(1, 1, "I am in window 1");

    this.window2 = new Window(5, 20, 1, 21);
    this.window2.box(0, 0);
    this.window2.mvprintw(1, 1, "I am in window 2");
  }

  public void run() {
    loop.run();
  }

  public void redraw() {
    this.window1.refresh();
    this.window2.refresh();
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
