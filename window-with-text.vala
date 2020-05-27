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

  private Window window;
  public void activate() {
    printw("I am on");
    mvprintw(0, 10, "stdscrn");
    mvprintw(1, 0, "and me on");
    mvprintw(1, 10, "stdscrn");

    this.window = new Window(5, 20, 1, 1);
    this.window.box(0, 0);
    this.window.mvprintw(1, 1, "I am in window");
  }

  public void run() {
    loop.run();
  }

  public void redraw() {
    refresh(); // \/ goes AFTER!
    this.window.refresh();
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
