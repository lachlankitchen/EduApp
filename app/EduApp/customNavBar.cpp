#include "customnavbar.h"

customNavBar::customNavBar(QObject *parent)
    : QAbstractItemModel(parent)
{
}

QVariant customNavBar::headerData(int section, Qt::Orientation orientation, int role) const
{
    // FIXME: Implement me!
}

QModelIndex customNavBar::index(int row, int column, const QModelIndex &parent) const
{
    // FIXME: Implement me!
}

QModelIndex customNavBar::parent(const QModelIndex &index) const
{
    // FIXME: Implement me!
}

int customNavBar::rowCount(const QModelIndex &parent) const
{
    if (!parent.isValid())
        return 0;

    // FIXME: Implement me!
}

int customNavBar::columnCount(const QModelIndex &parent) const
{
    if (!parent.isValid())
        return 0;

    // FIXME: Implement me!
}

QVariant customNavBar::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    // FIXME: Implement me!
    return QVariant();
}
