#include "TableModel.h"

TableModel::TableModel(QObject *parent): QAbstractTableModel(parent){}
TableModel::~TableModel(){}

void TableModel::setTableHeader(QVector<QString> value){
    /*if(value == nullptr){
        throw std::invalid_argument("In function \"setTableHeader\" argument \"value\" = nullptr");
    }*/
    if(__header.count() != 0){
        removeColumns(0, __header.count());
    }

    __header = value;

    insertColumns(0,__header.count());
}
void TableModel::setTableData(QVector<QVector<QVariant>> value){
    /*if(value == nullptr){
        throw std::invalid_argument("In function \"setTableData\" argument \"value\" = nullptr");
    }*/
    if(__data.count() != 0){
        removeColumns(0, __data.count());
    }

    __data = value;
    insertRows(0,__data.count());

}
QVector<QString> TableModel::getTableHeader(){
    return __header;
}
QVector<QVector<QVariant>> TableModel::getTableData(){
    return __data;
}
QVariant TableModel::headerData(int section, Qt::Orientation orientation, int role) const{
    if (orientation != Qt::Horizontal || role != Qt::DisplayRole || section >= columnCount()){
        qDebug() << "Section ERROR " << section ;
        return {};
    }
    qDebug() <<"Section "<< __header[section] << " ColumnCount = " << columnCount();
    return __header[section];
}
int TableModel::rowCount(const QModelIndex &parent) const{
    return __data.count();
}
int TableModel::columnCount(const QModelIndex &parent) const {
    return __header.count();
}
QVariant TableModel::data(const QModelIndex &index, int role) const{
    size_t row = index.row();
    size_t column = index.column();

    if(__data.size() == 0){
        return QVariant{};
    }

    if (row >= rowCount() || column >= columnCount() || role !=  Qt::DisplayRole){
        return QVariant{};
    }

    QVariant result;
    result = __data[row][column];

    return result;
}
Qt::ItemFlags TableModel::flags(const QModelIndex &index) const{
    return Qt::ItemIsSelectable | Qt::ItemIsUserCheckable;
}
QHash<int, QByteArray> TableModel::roleNames() const
{
    return { {Qt::DisplayRole, "display"} };
}
bool TableModel::setData(const QModelIndex &index, const QVariant &value, int role){
    size_t row = index.row();
    size_t column = index.column();

    if (row >= rowCount() || column >= columnCount()){
        return false;
    }
    emit dataChanged(index,index,{role});
    __data[row][column] = value;

    return true;
}
bool TableModel::insertRows(int row, int count, const QModelIndex &parent){

    beginInsertRows(parent,row,row+count-1);

    for(int i = 0 ; i < count; i++){
        for(int j = 0; j < __data[i].count(); j++){
            setData(createIndex(row + i,j),__data[row + i][j]);
        }
    }
    endInsertRows();

    return true;
}
bool TableModel::removeRows(int row, int count, const QModelIndex &parent){

    if(row + count > rowCount()){
        return false;
    }
    if(__data.count() == 0){
        return false;
    }

    beginRemoveRows(parent,row,row+count);
    for(int i = 0; i < count; i++){
        __data.removeAt(row);
    }
    endRemoveRows();

    return true;
}
bool TableModel::insertColumns(int column, int count, const QModelIndex &parent){
    beginInsertColumns(parent,column,column+count);
    endInsertColumns();
    return true;
}
bool TableModel::removeColumns(int column, int count, const QModelIndex &parent){
    if(column + count > columnCount()){
        return false;
    }
    if(__header.count() == 0){
        return false;
    }

    beginRemoveColumns(parent,column,column+count);
    for(int i = 0; i < count; i++){
        __header.removeAt(column);
    }
    endRemoveColumns();

    return true;
}
