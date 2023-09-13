#pragma once
/********************************************************************************
** Form generated from reading UI file ''
**
** Created by: Qt User Interface Compiler version 6.5.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_navbar
{
public:
    QPushButton *pushButton;
    QPushButton *pushButton_2;
    QPushButton *pushButton_3;

    void setupUi(QWidget *navbar)
    {
        if (navbar->objectName().isEmpty())
            navbar->setObjectName("navbar");
        navbar->resize(400, 300);
        pushButton = new QPushButton(navbar);
        pushButton->setObjectName("pushButton");
        pushButton->setGeometry(QRect(20, 250, 100, 32));
        pushButton_2 = new QPushButton(navbar);
        pushButton_2->setObjectName("pushButton_2");
        pushButton_2->setGeometry(QRect(150, 250, 100, 32));
        pushButton_3 = new QPushButton(navbar);
        pushButton_3->setObjectName("pushButton_3");
        pushButton_3->setGeometry(QRect(290, 250, 100, 32));

        retranslateUi(navbar);

        QMetaObject::connectSlotsByName(navbar);
    } // setupUi

    void retranslateUi(QWidget *navbar)
    {
        navbar->setWindowTitle(QCoreApplication::translate("navbar", "Form", nullptr));
        pushButton->setText(QCoreApplication::translate("navbar", "screen1", nullptr));
        pushButton_2->setText(QCoreApplication::translate("navbar", "screen2", nullptr));
        pushButton_3->setText(QCoreApplication::translate("navbar", "screen3", nullptr));
    } // retranslateUi

};

namespace Ui {
class navbarWidget: public Ui_navbar {};
} // namespace Ui

QT_END_NAMESPACE

