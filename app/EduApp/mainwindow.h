#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QStackedWidget>
#include <QWidget>
#include "customNavBar.h" // Include the custom navigation bar header

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void showScreen1();
    void showScreen2();
    void showScreen3();

private:
    Ui::MainWindow *ui;
    QWidget *screen1;
    QWidget *screen2;
    QWidget *screen3;
    navbar *navigationBar; // Declare the navigation bar variable
};
#endif // MAINWINDOW_H
