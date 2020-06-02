namespace Curses {
  [Compact]
  [CCode (free_function = "free_menu", cname = "MENU", cprefix = "", cheader_filename = "menu.h")]
  public class Menu {
    [CCode (cname = "new_menu")]
    public Menu([CCode (array_length = false)] MenuItem[] items);
    [CCode (cname = "post_menu")]
    public int post();
    [CCode (cname = "unpost_menu")]
    public int unpost();
    [CCode (cname = "menu_driver")]
    public int driver(int c);
  }

  [Compact]
  [CCode (free_function = "free_item", cname = "ITEM", cprefix = "", cheader_filename = "menu.h")]
  public class MenuItem {
    [CCode (cname = "new_item")]
    public MenuItem(string name, string description);
  }

  [CCode (cprefix = "REQ_", has_type_id = false)]
  public enum MenuRequest {
       LEFT_ITEM,
       RIGHT_ITEM,
       UP_ITEM,
       DOWN_ITEM,
       SCR_ULINE,
       SCR_DLINE,
       SCR_DPAGE,
       SCR_UPAGE,
       FIRST_ITEM,
       LAST_ITEM,
       NEXT_ITEM,
       PREV_ITEM,
       TOGGLE_ITEM,
       CLEAR_PATTERN,
       BACK_PATTERN,
       NEXT_MATCH,
       PREV_MATCH
  }

  [CCode (cprefix = "E_", has_type_id = false)]
  public enum MenuError {
       OK,
       CONNECTED,
       NOT_CONNECTED,
       SYSTEM_ERROR,
       BAD_ARGUMENT,
       BAD_STATE,
       NO_ROOM,
       POSTED,
       NOT_POSTED
  }
}
