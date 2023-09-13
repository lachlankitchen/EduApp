#ifndef CUSTOMNAVBAR_H
#define CUSTOMNAVBAR_H

#include <QWidget>

namespace Ui {
class navbarWidget;
}

class navbar : public QWidget
{
    Q_OBJECT

public:
    explicit navbar(QWidget *parent = nullptr);
    ~navbar();

    // Declare the signals with the same name as used in your connection in MainWindow
signals:
    void requestScreen1(); // Signal for switching to Screen 1
    void requestScreen2(); // Signal for switching to Screen 2
    void requestScreen3(); // Signal for switching to Screen 3

private:
    Ui::navbarWidget *ui;
};

#endif // CUSTOMNAVBAR_H
