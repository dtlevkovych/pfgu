#include <gnome.h>

#define MY_APP_TITLE "Gnome Example Program"
#define MY_APP_ID "gnome-example"
#define MY_APP_VERSION "1.000"
#define MY_BUTTON_TEXT "I Want to Quit the GNOME Example Program"
#define MY_QUIT_QUESTION "Are you sure you want to quit?"

int destroy_handler(gpointer window, GdkEventAny *e, gpointer data);
int delete_handler(gpointer window, GdkEventAny *e, gpointer data);
int click_handler(gpointer window, GdkEventAny *e, gpointer data);

int main(int argc, char **argv)
{
    gpointer appPtr;
    gpointer btnQuit;

    gnome_init(MY_APP_ID, MY_APP_VERSION, argc, argv);

    appPtr = gnome_app_new(MY_APP_ID, MY_APP_TITLE);
    btnQuit = gtk_button_new_with_label(MY_BUTTON_TEXT);

    gnome_app_set_contents(appPtr, btnQuit);

    gtk_widget_show(btnQuit);
    gtk_widget_show(appPtr);

    gtk_signal_connect(appPtr, "delete_event", GTK_SIGNAL_FUNC(delete_handler), NULL);
    gtk_signal_connect(appPtr, "destroy", GTK_SIGNAL_FUNC(destroy_handler), NULL);
    gtk_signal_connect(btnQuit, "clicked", GTK_SIGNAL_FUNC(click_handler), NULL);

    gtk_main();
    return 0;
}

int destroy_handler(gpointer window, GdkEventAny *e, gpointer data)
{
    gtk_main_quit();
    return 0;
}

int delete_handler(gpointer window, GdkEventAny *e, gpointer data)
{
    return 0;
}

int click_handler(gpointer window, GdkEventAny *e, gpointer data)
{
    gpointer msgbox;
    int buttonClicked;

    msgbox = gnome_message_box_new(
        MY_QUIT_QUESTION,
        GNOME_MESSAGE_BOX_QUESTION,
        GNOME_STOCK_BUTTON_YES,
        GNOME_STOCK_BUTTON_NO,
        NULL);

    gtk_window_set_modal(msgbox, 1);
    gtk_widget_show(msgbox);

    buttonClicked = gnome_dialog_run_and_close(msgbox);

    if (buttonClicked == 0) {
        gtk_main_quit();
    }

    return 0;
}
