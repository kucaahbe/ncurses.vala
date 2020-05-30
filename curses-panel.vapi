namespace Curses {
  [Compact]
  [CCode (free_function = "del_panel", cname = "PANEL", cprefix = "", cheader_filename = "panel.h")]
  public class Panel {
    [CCode (cname = "new_panel")]
    public Panel(Window win);

    public Window window {
      [CCode (cname = "panel_window")] get;
    }

    [CCode (cname = "replace_panel")]
    public int replace(Window win);

    public void * userptr {
      [CCode (cname = "panel_userptr")]     get;
      [CCode (cname = "set_panel_userptr")] set;
    }
    [CCode (cname = "top_panel")]
    public int top();
    [CCode (cname = "bottom_panel")]
    public int botton();
    [CCode (cname = "show_panel")]
    public int show();
    [CCode (cname = "hide_panel")]
    public int hide();

    [CCode (cname = "move_panel")]
    public int move(int y, int x);

    public static void update_panels();
  }
}
