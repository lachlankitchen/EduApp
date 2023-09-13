#include "customNavBar.h"
#include "ui_customNavBar.h"
#include <QHBoxLayout> // Include QHBoxLayout header for button layout

customNavBar::customNavBar(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::customNavBar)
{
    ui->setupUi(this);

    // Create a QWidget container for the buttons
    QWidget* buttonContainer = new QWidget(this);

    // Create a QHBoxLayout for the button layout
    QHBoxLayout *buttonLayout = new QHBoxLayout(buttonContainer);

    // Create the buttons for navigation
    QPushButton *screen1Button = new QPushButton("Screen 1", this);
    QPushButton *screen2Button = new QPushButton("Screen 2", this);
    QPushButton *screen3Button = new QPushButton("Screen 3", this);

    // Add the buttons to the layout
    buttonLayout->addWidget(screen1Button);
    buttonLayout->addWidget(screen2Button);
    buttonLayout->addWidget(screen3Button);

    // Connect the buttons to their respective signals
    connect(screen1Button, &QPushButton::clicked, this, &customNavBar::requestScreen1);
    connect(screen2Button, &QPushButton::clicked, this, &customNavBar::requestScreen2);
    connect(screen3Button, &QPushButton::clicked, this, &customNavBar::requestScreen3);

    // Set the layout for the container widget
    buttonContainer->setLayout(buttonLayout);
}

customNavBar::~customNavBar()
{
    delete ui;
}
