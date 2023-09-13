#include "screen1.h"
#include "customNavBar.h" // Include custom navigation bar header
#include <QLabel>   // Include QLabel header
#include <QVBoxLayout>
#include <QSpacerItem> // Include QSpacerItem for spacing

Screen1::Screen1(QWidget *parent)
    : QWidget(parent)
{
    // Create a QLabel for the "Screen 1" text
    QLabel *label = new QLabel("Screen 1", this);
    label->setAlignment(Qt::AlignCenter); // Center-align the text
    label->setStyleSheet("font-size: 24px;"); // Set font size

    // Create an instance of the custom navigation bar
    navbar *navBar = new navbar(this);

    // Create a QVBoxLayout for the screen1 layout
    QVBoxLayout *layout = new QVBoxLayout(this);
    layout->setContentsMargins(20, 20, 20, 20); // Set margins (left, top, right, bottom)
    layout->setSpacing(10); // Set spacing between widgets

    // Add the navigation bar and label to the layout
    layout->addWidget(navBar);
    layout->addWidget(label);

    // Add spacing between the navigation bar and label
    layout->addSpacerItem(new QSpacerItem(20, 20, QSizePolicy::Minimum, QSizePolicy::Expanding));
}
