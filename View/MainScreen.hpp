#ifndef MAINSCREEN_HPP
#define MAINSCREEN_HPP

#include <QObject>
#include <qqml.h>
#include <../Controller/GenerateController.hpp>
#include <QTextDocument>
#include <QFile>
#include <QTextStream>
#include <QMap>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonValue>

class MainScreen: public QObject
{
    Q_OBJECT
    QML_ELEMENT
private:
    GenerateController __generate_contr;
    QVector<QPair<QString,QVector<QPair<QString,QString>>>> __dma;
    QStringList __alphabet_list;
public:

    MainScreen(QObject *parent = nullptr);

public slots:
    void generateDMA(QString start_change, QString end_change, QString alphabet);
    void startGenerated(QString change);
    void analizeFile(QString path);
    void saveFile(QString path);

    QVector<QString> generateTableHeader();
    QVector<QVector<QVariant>> generateTableData();
    QJsonObject getDMA();
    int getAlphabetSize();
signals:
    void generatedStatus(QString error_msg);
    void setGramaticks(QString alphabet, QString start_chain, QString end_chain);
    void showResult(QString result);
    void displayTable(QString dma);
};

#endif // MAINSCREEN_HPP
