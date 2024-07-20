#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

extern int magic2Input;
extern int tpNumberFirstInput;
extern int tpNumberInput;

extern int magic1Global;

extern int magic3ArrGlobal[];
extern double priceStartArrGlobal[];
extern string takeProfitCurrentArrGlobal[];
extern string takeProfitStartArrGlobal[];
extern int totalPositionArrGlobal[];
extern double slAmountArrGlobal[];

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;

int GetGridNoByComment(string comment)
{
    return (int)StringToInteger(comment);
}

ulong GetMagicNumber(int magic3)
{
    string magicStr = GetMagic1And2Str() + IntegerToString(magic3);
    return StringToInteger(magicStr);
}

string GetMagic1And2Str()
{
    return IntegerToString(magic1Global) + "0" + IntegerToString(magic2Input) + "0";
}

bool IsCorrectMagic(ulong magic)
{
    string magicStr = IntegerToString(magic);
    return StringSubstr(magicStr, 0, StringLen(magicStr) - 1) == GetMagic1And2Str();
}

int GetMagic3ByMagic(ulong magic)
{
    string magicStr = IntegerToString(magic);
    return (int)StringToInteger(StringSubstr(magicStr, StringLen(magicStr) - 1));
}

void CopyArrInt(int &source[], int &taget[])
{
    int size = ArraySize(source);
    ArrayResize(taget, size);
    for (int i = 0; i < size; i++)
    {
        taget[i] = source[i];
    }
}

bool IsCorrectMagicByMagic3(ulong magic, int magic3)
{
    return magic == GetMagicNumber(magic3);
}

int GetMagicOrdinalByMagic3(int magic3)
{
    for (int i = 0; i < ArraySize(magic3ArrGlobal); i++)
    {
        if (magic3ArrGlobal[i] == magic3)
        {
            return i;
        }
    }
    return -1;
}

int AddArrValueInt(int &arr[], int value)
{
    int ordinal = ArraySize(arr);
    ArrayResize(arr, ordinal + 1);
    arr[ordinal] = value;
    return ordinal + 1;
}

bool IsEqualArrInt(int &arr1[], int &arr2[])
{
    int size1 = ArraySize(arr1);
    int size2 = ArraySize(arr2);
    if (size1 != size2)
    {
        return false;
    }
    for (int i = 0; i < size1; i++)
    {
        if (arr1[i] != arr2[i])
        {
            return false;
        }
    }
    return true;
}

bool IsContainsValueInt(int &arr[], int value)
{
    for (int i = 0; i < ArraySize(arr); i++)
    {
        if (arr[i] == value)
        {
            return true;
        }
    }
    return false;
}

int GetTotalPosition()
{
    int result = 0;
    int totalPosition = PositionsTotal();
    for (int i = 0; i < totalPosition; i++)
    {
        ulong positionTicket = PositionGetTicket(i);
        if (IsCorrectMagic(PositionGetInteger(POSITION_MAGIC)))
        {
            result++;
        }
    }
    return result;
}

int GetTotalPositionByMagic3(int magic3)
{
    int result = 0;
    for (int i = 0; i < PositionsTotal(); i++)
    {
        ulong positionTicket = PositionGetTicket(i);
        if (IsCorrectMagicByMagic3(PositionGetInteger(POSITION_MAGIC), magic3))
        {
            result++;
        }
    }
    return result;
}

// if value1 > value2 -> return 1
// if value1 = value2 -> return 0
// if value1 < value2 -> return -1
int CompareDouble(double value1, double value2)
{
    int value1Int = (int)MathRound(value1 * 100000);
    int value2Int = (int)MathRound(value2 * 100000);

    if (value1Int > value2Int)
    {
        return 1;
    }
    else if (value1Int < value2Int)
    {
        return -1;
    }
    return 0;
}

int GetTotalOrderByMagic3(int magic3)
{
    int result = 0;
    int totalOrder = OrdersTotal();
    for (int i = 0; i < totalOrder; i++)
    {
        ulong ticket = OrderGetTicket(i);
        if (IsCorrectMagicByMagic3(OrderGetInteger(ORDER_MAGIC), magic3))
        {
            result++;
        }
    }
    return result;
}

double GetSLByMagic3(int magic3)
{
    int magicOrdinal = GetMagicOrdinalByMagic3(magic3);
    if (takeProfitStartArrGlobal[magicOrdinal] == BUY_TYPE_CONSTANT && takeProfitCurrentArrGlobal[magicOrdinal] == BUY_TYPE_CONSTANT)
    {
        return priceStartArrGlobal[magicOrdinal] - slAmountArrGlobal[magicOrdinal];
    }
    else if (takeProfitStartArrGlobal[magicOrdinal] == SELL_TYPE_CONSTANT && takeProfitCurrentArrGlobal[magicOrdinal] == SELL_TYPE_CONSTANT)
    {
        return priceStartArrGlobal[magicOrdinal] + slAmountArrGlobal[magicOrdinal];
    }
    return priceStartArrGlobal[magicOrdinal];
}

double GetTPByMagic3(int magic3)
{
    int magicOrdinal = GetMagicOrdinalByMagic3(magic3);
    double priceStart = priceStartArrGlobal[magicOrdinal];
    if (takeProfitStartArrGlobal[magicOrdinal] == BUY_TYPE_CONSTANT)
    {
        if (totalPositionArrGlobal[magicOrdinal] == 1)
        {
            return priceStart + (slAmountArrGlobal[magicOrdinal] * tpNumberFirstInput);
        }
        else if (takeProfitCurrentArrGlobal[magicOrdinal] == BUY_TYPE_CONSTANT)
        {
            return priceStart + (slAmountArrGlobal[magicOrdinal] * tpNumberInput);
        }
        return priceStart - (slAmountArrGlobal[magicOrdinal] * (tpNumberInput + 1));
    }
    else
    {
        if (totalPositionArrGlobal[magicOrdinal] == 1)
        {
            return priceStart - (slAmountArrGlobal[magicOrdinal] * tpNumberFirstInput);
        }
        else if (takeProfitCurrentArrGlobal[magicOrdinal] == SELL_TYPE_CONSTANT)
        {
            return priceStart - (slAmountArrGlobal[magicOrdinal] * tpNumberInput);
        }
        return priceStart + (slAmountArrGlobal[magicOrdinal] * (tpNumberInput + 1));
    }
}
