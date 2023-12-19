#include "GenerateModel.hpp"
using namespace model;



GenerateModel::GenerateModel()
{

}
QVector<QPair<QString,QVector<QPair<QString,QString>>>> GenerateModel::generateDMA(QString start_change, QString end_change, QString alphabet)
{
    //<правило начальное, <символ, правило конченое>>
    QVector<QPair<QString,QVector<QPair<QString,QString>>>> result;
    QStringList alphabet_list = alphabet.split(",");
    int counter_command = 0;
    QString current_command;
    int middle_command;
    qDebug() << start_change << end_change <<  alphabet;

    QVector<QPair<QString,QString>> alphabet_pairs;
    //начальная подцепочка
    for(auto i = start_change.begin(), i_end = start_change.end(); i != i_end; i++)
    {
        alphabet_pairs.clear();
        current_command = QString("q") + QString("").setNum(counter_command);

        for(auto j = alphabet_list.begin(), j_end = alphabet_list.end(); j != j_end; j++)
        {
            if(*i == *j){
                alphabet_pairs.push_back(qMakePair(*i,QString("q") + QString("").setNum(counter_command+1)));
                continue;
            }
            alphabet_pairs.push_back(qMakePair(*j,""));

        }
        result.push_back(qMakePair(current_command,alphabet_pairs));
        counter_command++;
    }

    //состояние по середине
    current_command = QString("q") + QString("").setNum(counter_command);
    middle_command = counter_command;
    alphabet_pairs.clear();
    for(auto i = alphabet_list.begin(), i_end = alphabet_list.end(); i != i_end; i++)
    {
        if(*i == end_change.front()){
            alphabet_pairs.push_back(qMakePair(*i,QString("q") + QString("").setNum(counter_command+1)));
        }
        else{
            alphabet_pairs.push_back(qMakePair(*i,current_command));
        }
    }
    result.push_back(qMakePair(current_command,alphabet_pairs));
    counter_command++;

    //конечная подцепочка
    for(auto i = end_change.begin()+1, i_end = end_change.end(); i != i_end; i++)
    {
        alphabet_pairs.clear();
        current_command = QString("q") + QString("").setNum(counter_command);


        for(auto j = alphabet_list.begin(), j_end = alphabet_list.end(); j != j_end; j++)
        {
            if(*i == *j){
                if(i+1 == i_end){
                    alphabet_pairs.push_back(qMakePair(*i,"qf"));
                }
                else{
                    alphabet_pairs.push_back(qMakePair(*i,QString("q") + QString("").setNum(counter_command+1)));
                }
            }
            else if(*j == end_change.front()){
                qDebug() << QString("q") + QString("").setNum(middle_command+1);
                alphabet_pairs.push_back(qMakePair(*j,QString("q") + QString("").setNum(middle_command+1)));
            }
            else{
                alphabet_pairs.push_back(qMakePair(*j,QString("q") + QString("").setNum(middle_command)));
            }
        }
        result.push_back(qMakePair(current_command,alphabet_pairs));
        counter_command++;
    }
    //финаьлное состояние
    current_command = QString("qf");
    alphabet_pairs.clear();
    for(auto i = alphabet_list.begin(), i_end = alphabet_list.end(); i != i_end; i++)
    {
        if(*i == end_change.front()){
            alphabet_pairs.push_back(qMakePair(*i,QString("q") + QString("").setNum(middle_command+1)));
        }
        else{
            alphabet_pairs.push_back(qMakePair(*i,QString("q") + QString("").setNum(middle_command)));
        }
    }
    result.push_back(qMakePair(current_command,alphabet_pairs));
    counter_command++;
    qDebug() << result;
    return result;
}
QString GenerateModel::generateChains(QVector<QPair<QString,QVector<QPair<QString,QString>>>> &data,
                                      QString start_rule, QString end_rule, QString change, QString &err_msg)
{
    QString result = "(" + start_rule + ", " + change + ") |- ";
    QString active_rule = start_rule, temp_change = change;
    err_msg = "";
    bool found = false;;
    for(auto i = change.begin(), end = change.end(); i != end; i++){
        found = false;
        for(auto j = data.begin(), end_j = data.end(); j != end_j; j++)
        {
            if((*j).first == active_rule){
                found = true;
                active_rule = "";
                for(auto k = (*j).second.begin(), end_k =(*j).second.end(); k != end_k; k++)
                {
                    if((*k).first == *i){
                        active_rule = (*k).second;
                        break;
                    }
                }
                break;
            }
        }

        if(!found){
            err_msg = "Ошибка! Правило не было найдено";
            break;
        }
        else if(active_rule == ""){
            if(temp_change != ""){
                err_msg = "Ошибка! Цепочка не пуста, но автомат находится в конечном состоянии";
                break;
            }
            err_msg = "Ошибка! Цепочка содержит символ не относящийся к алфавиту автомата";
            break;
        }

        temp_change = temp_change.remove(0,1);
        result += "(" + active_rule + ", " + temp_change + ") |- ";
    }

    QStringList end_rules = end_rule.split(",");
    if(err_msg == ""){
        bool found = false;
        for(auto i = end_rules.begin(), end = end_rules.end(); i != end; i++){
            if(*i == active_rule){
                found = true;
                break;
            }
        }
        if(!found){
            err_msg = "Ошибка! Автомат находится не в конечном состоянии";
        }
    }
    result = result.remove(result.length() - 3, 3);
    return result;
}
