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

    [CCode (cname = "set_menu_opts")]
    public int set_options(MenuOption opts);
    public MenuOption options {
      [CCode (cname = "menu_opts")]     get;
    }
    [CCode (cname = "menu_opts_on")]
    public int set_options_on(MenuOption opts);
    [CCode (cname = "menu_opts_off")]
    public int set_options_off(MenuOption opts);

    [CCode (cname = "set_menu_win")]
    public int set_window(Window win);
    public Window window {
      [CCode (cname = "menu_win")]     get;
    }
    [CCode (cname = "set_menu_sub")]
    public int set_sub_window(Window sub);
    public Window sub_window {
      [CCode (cname = "menu_sub")]     get;
    }

    [CCode (cname = "scale_menu")]
    public int scale(out int rows, out int columns);

    [CCode (cname = "set_menu_mark")]
    public int set_mark(string mark);
    public string? mark {
      [CCode (cname = "menu_mark")]     get;
    }

    [CCode (cname = "set_menu_format")]
    public int set_format(int rows, int cols);
    [CCode (cname = "menu_format")]
    public void format(out int rows, out int cols);

    [CCode (cname = "set_menu_fore")]
    public int set_fore(int attr);
    public int fore {
      [CCode (cname = "menu_fore")]     get;
    }
    [CCode (cname = "set_menu_back")]
    public int set_back(int attr);
    public int back {
      [CCode (cname = "menu_back")]     get;
    }
    [CCode (cname = "set_menu_grey")]
    public int set_grey(int attr);
    public int grey {
      [CCode (cname = "menu_grey")]     get;
    }
    [CCode (cname = "set_menu_pad")]
    public int set_pad(int attr);
    public int pad {
      [CCode (cname = "menu_pad")]     get;
    }

    [CCode (cname = "set_current_item")]
    public int set_current_item(MenuItem item);
    public MenuItem current_item {
      [CCode (cname = "current_item")]     get;
    }

    [CCode (cname = "set_top_row")]
    public int set_top_row(int row);
    public int top_row {
      [CCode (cname = "top_row")]     get;
    }

    [CCode (cname = "pos_menu_cursor")]
    public int pos_cursor();
  }

  [Compact]
  [CCode (free_function = "free_item", cname = "ITEM", cprefix = "", cheader_filename = "menu.h")]
  public class MenuItem {
    [CCode (cname = "new_item")]
    public MenuItem(string name, string description);

    public string name {
      [CCode (cname = "item_name")]     get;
    }
    public string description {
      [CCode (cname = "item_description")]     get;
    }
    public int index {
      [CCode (cname = "item_index")]     get;
    }

    [CCode (cname = "set_item_opts")]
    public int set_opts(ItemOption opts);
    [CCode (cname = "item_opts_on")]
    public int opts_on(ItemOption opts);
    [CCode (cname = "item_opts_off")]
    public int opts_off(ItemOption opts);
    public ItemOption opts {
      [CCode (cname = "item_opts")]     get;
    }

    [CCode (cname = "set_item_userptr")]
    public int set_userptr(void * userptr);
    public void * userptr {
      [CCode (cname = "item_userptr")]     get;
    }
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

  [CCode (cname = "Menu_Options", cprefix = "O_", has_type_id = false)]
  public enum MenuOption {
       ONEVALUE,
       SHOWDESC,
       ROWMAJOR,
       IGNORECASE,
       SHOWMATCH,
       NONCYCLIC
  }

  [CCode (cname = "Item_Options", cprefix = "O_", has_type_id = false)]
  public enum ItemOption {
       SELECTABLE
  }
}
