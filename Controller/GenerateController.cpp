#include "GenerateController.hpp"

GenerateController::GenerateController()
{

}
QVector<QPair<QString,QVector<QPair<QString,QString>>>> GenerateController::generateDMA(QString start_change, QString end_change, QString alphabet)
{
    return gen_model.generateDMA(start_change,end_change,alphabet);
}
GenerateController::STATUS_CODE_T GenerateController::startGenerated(QVector<QPair<QString,QVector<QPair<QString,QString>>>> &data,
                                                                     QString change, QString &result, QString &err_msg)
{
    result = gen_model.generateChains(data,START_RULE, END_RULE,change, err_msg);
    if(err_msg != ""){
        return STATUS_CODE_T::ERROR;
    }
    return STATUS_CODE_T::SUCCESS;
}
