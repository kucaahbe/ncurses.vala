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
    [CCode (cname = "panel_above")]
    public unowned Panel? above();
    [CCode (cname = "panel_below")]
    public unowned Panel? below();
    [CCode (cname = "show_panel")]
    public int show();
    [CCode (cname = "hide_panel")]
    public int hide();
    [CCode (cname = "panel_hidden")]
    public int hidden();

    [CCode (cname = "move_panel")]
    public int move(int y, int x);

    [CCode (cname = "panel_above")]
    public static unowned Panel? above_all(Panel? panel = null);
    [CCode (cname = "panel_below")]
    public static unowned Panel? below_all(Panel? panel = null);
    public static void update_panels();
  }
}
