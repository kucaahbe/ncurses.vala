namespace Curses {
  [Compact]
  [CCode (free_function = "del_panel", cname = "PANEL", cprefix = "", cheader_filename = "panel.h")]
  public class Panel {
    [CCode (cname = "new_panel")]
    public Panel(Window win);

    public static void update_panels();
  }
}
