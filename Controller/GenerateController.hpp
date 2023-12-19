#ifndef GENERATECONTROLLER_HPP
#define GENERATECONTROLLER_HPP

#include <QString>
#include <QStringList>
#include <QMap>
#include <../Model/GenerateModel.hpp>
#include <QDebug>

class GenerateController
{
private:
    model::GenerateModel gen_model;
public:
    enum STATUS_CODE_T{
        SUCCESS = 0,
        ERROR
    };
    const QString START_RULE = "q0";
    const QString END_RULE = "qf";
    GenerateController();
    QVector<QPair<QString,QVector<QPair<QString,QString>>>> generateDMA(QString start_change, QString end_change, QString alphabet);
    GenerateController::STATUS_CODE_T startGenerated(QVector<QPair<QString,QVector<QPair<QString,QString>>>> &data,
                                                     QString change, QString &result, QString &err_msg);
};

#endif // GENERATECONTROLLER_HPP
