#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "customNavBar.h" // Include the custom navigation bar header
#include <QVBoxLayout> // Include the QVBoxLayout header

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    // Create instances of your screens
    screen1 = new QWidget();
    screen2 = new QWidget();
    screen3 = new QWidget();

    // Add screens to the stacked widget
    ui->stackedWidget->addWidget(screen1);
    ui->stackedWidget->addWidget(screen2);
    ui->stackedWidget->addWidget(screen3);

    // Create an instance of the custom navigation bar
    navigationBar = new navbar(this);

    // Create a central widget to contain the stacked widget and navigation bar
    QWidget *centralWidget = new QWidget(this);
    setCentralWidget(centralWidget);

    // Create a layout for the central widget
    QVBoxLayout *centralLayout = new QVBoxLayout(centralWidget);
    centralLayout->addWidget(navigationBar); // Add the navigation bar to the layout
    centralLayout->addWidget(ui->stackedWidget); // Add the stacked widget to the layout

    // Connect the custom navigation bar signal to a slot for handling screen changes
    connect(navigationBar, &navbar::requestScreen1, this, &MainWindow::showScreen1);
    connect(navigationBar, &navbar::requestScreen2, this, &MainWindow::showScreen2);
    connect(navigationBar, &navbar::requestScreen3, this, &MainWindow::showScreen3);

    // Show the initial screen (assuming screen1 is the initial screen)
    showScreen1();
}

void MainWindow::showScreen1()
{
    ui->stackedWidget->setCurrentWidget(screen1);
}

void MainWindow::showScreen2()
{
    ui->stackedWidget->setCurrentWidget(screen2);
}

void MainWindow::showScreen3()
{
    ui->stackedWidget->setCurrentWidget(screen3);
}



MainWindow::~MainWindow()
{
    delete ui;
}
