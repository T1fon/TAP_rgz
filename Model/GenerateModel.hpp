#ifndef GENERATEMODEL_HPP
#define GENERATEMODEL_HPP
#include <QVector>
#include <QMap>
#include <QDebug>
#include <QPair>


namespace model{

class GenerateModel
{
private:

public:
    GenerateModel();
    QVector<QPair<QString,QVector<QPair<QString,QString>>>> generateDMA(QString start_change, QString end_change, QString alphabet);
    QString generateChains(QVector<QPair<QString,QVector<QPair<QString,QString>>>> &data,
                           QString start_rule, QString end_rule, QString change, QString &err_msg);
};
}

#endif // GENERATEMODEL_HPP
