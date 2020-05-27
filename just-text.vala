using Curses;
using Posix;

public int main(string[] args) {
  var loop = new MainLoop();
  
  TimeoutSource time = new TimeoutSource (2000);
  time.set_callback (() => { loop.quit(); return false; });
  time.attach(loop.get_context());

  initscr();
  noecho();

  printw("SRAKA");
  refresh();

  loop.run();

  endwin();

  return EXIT_SUCCESS;
}
