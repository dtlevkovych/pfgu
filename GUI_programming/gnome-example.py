import gtk
import gnome.ui

def destroy_handler(event):
    gtk.mainquit()
    return 0

def delete_handler(window, event):
    return 0

def click_handler(event):
    msgbox = gnome.ui.GnomeMessageBox(
        "Are you sure you want to quit?",
        gnome.ui.MESSAGE_BOX_QUESTION,
        gnome.ui.STOCK_BUTTON_YES,
        gnome.ui.STOCK_BUTTON_NO)

    msgbox.set_modal(1)
    msgbox.show()

    result = msgbox.run_and_close()

    if result == 0:
        gtk.mainquit()

    return 0

myapp = gnome.ui.GnomeApp("gnome-example", "Gnome Example Program")
mybutton = gtk.GtkButton("I Want to Quit the GNOME Example program")
myapp.set_contents(mybutton)

mybutton.show()
myapp.show()

myapp.connect("delete_event", delete_handler)
myapp.connect("destroy", destroy_handler)
mybutton.connect("clicked", click_handler)

gtk.mainloop()
