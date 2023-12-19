#include "MainScreen.hpp"

MainScreen::MainScreen(QObject *parent): QObject(parent)
{

}
void MainScreen::generateDMA(QString start_change, QString end_change, QString alphabet){
    __alphabet_list = alphabet.split(",");
    bool found;
    for(auto i = start_change.begin(), end_i = start_change.end(); i != end_i; i++)
    {
        found = false;
        for(auto j = __alphabet_list.begin(), end_j = __alphabet_list.end(); j != end_j; j++)
        {
            if(*i == *j){
                found = true;
                break;
            }
        }
        if(!found){
            emit generatedStatus("Начальная цепочка содержит символы не относящиеся к алфавиту");
            return;
        }
    }
    for(auto i = end_change.begin(), end_i = end_change.end(); i != end_i; i++)
    {
        found = false;
        for(auto j = __alphabet_list.begin(), end_j = __alphabet_list.end(); j != end_j; j++)
        {
            if(*i == *j){
                found = true;
                break;
            }
        }
        if(!found){
            emit generatedStatus("Конечная цепочка содержит символы не относящиеся к алфавиту");
            return;
        }
    }
    __dma = __generate_contr.generateDMA(start_change,end_change,alphabet);
}
void MainScreen::startGenerated(QString change){
    QString result, err_msg;
    GenerateController::STATUS_CODE_T status;

    status = __generate_contr.startGenerated(__dma,change, result, err_msg);

    if(status != GenerateController::STATUS_CODE_T::SUCCESS){
        emit generatedStatus(err_msg);
    }
    emit showResult(result);
}
void MainScreen::analizeFile(QString path){
    path.remove(0,8);
    QFile file(path);
    qDebug() << "path = " << path;
    if(!file.open(QFile::ReadOnly)){
        qDebug() << "open error";
        emit setGramaticks("Error", "Error","Error");
        return;
    }
    QTextStream t_stream(&file);
    QString alphabet, start_chain, end_chain;
    t_stream >> alphabet >> start_chain >> end_chain;
    emit setGramaticks(alphabet, start_chain,end_chain);
    file.close();
}
void MainScreen::saveFile(QString path){
    path.remove(0,8);
    QFile file(path);
    qDebug() << "path = " << path;
    if(!file.open(QFile::WriteOnly)){
        qDebug() << "save error";
        emit generatedStatus("Не удалось сохранить данные в файл");
        return;
    }
    QTextStream t_stream(&file);
    t_stream << __alphabet_list.size() << " \n";
    for(auto i = __alphabet_list.begin(), end_i = __alphabet_list.end(); i != end_i; i++)
    {
        t_stream << *i << " ";
    }
    t_stream << "\n";

    t_stream << __dma.size() << " " << __alphabet_list.size() + 1 << "\n";
    for(auto i = __dma.begin(), end_i = __dma.end(); i != end_i; i++)
    {
        t_stream << (*i).first << " ";
        for(auto j = (*i).second.begin(), end_j = (*i).second.end(); j != end_j; j++)
        {
            if((*j).second == ""){
                t_stream << "_" << " ";
            }
            t_stream << (*j).second << " ";
        }
        t_stream << "\n";
    }
    file.close();
}
QVector<QString> MainScreen::generateTableHeader(){
    QVector<QString> result;
    result.push_back("Правила\\алфавит");
    for(auto i = __alphabet_list.begin(), end_i = __alphabet_list.end(); i != end_i; i++)
    {
        result.push_back(*i);
    }
    return result;
}
QVector<QVector<QVariant>> MainScreen::generateTableData(){
    QVector<QVector<QVariant>> result;
    QVector<QVariant> temp_data;
    temp_data.push_back("Правила\\алфавит");
    for(auto i = __alphabet_list.begin(), end_i = __alphabet_list.end(); i != end_i; i++)
    {
        temp_data.push_back(*i);
    }
    result.push_back(temp_data);
    for(auto i = __dma.begin(), end_i = __dma.end(); i != end_i; i++)
    {
        temp_data.clear();
        temp_data.push_back((*i).first);
        for(auto j = (*i).second.begin(), end_j = (*i).second.end(); j != end_j; j++)
        {
            temp_data.push_back((*j).second);
        }
        result.push_back(temp_data);
    }
    return result;
}
QJsonObject MainScreen::getDMA(){
    QJsonArray result;
    QJsonArray data;
    QJsonObject temp;
    for(auto i = __dma.begin(), end_i = __dma.end(); i != end_i; i++)
    {
        temp = QJsonObject();
        temp["key"] = (*i).first;
        for(auto j = (*i).second.begin(),end_j = (*i).second.end(); j != end_j; j++)
        {
            QJsonObject temp_obj;
            temp_obj["symbol"] = (*j).first;
            temp_obj["rule_end"] = (*j).second;
            data.push_back(temp_obj);
        }
        temp["value"] = data;
        result.push_back(temp);
    }
    QJsonObject end_result;
    end_result["data"] = result;
    return end_result;
}
int MainScreen::getAlphabetSize(){
    return __alphabet_list.size();
}
