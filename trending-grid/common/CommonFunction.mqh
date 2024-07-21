#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

extern int magic2Input;

extern int magic1Global;
extern ulong magicNoGlobal;

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;

string GetPositionTypeStr(ENUM_POSITION_TYPE type)
{
    if (type == POSITION_TYPE_BUY)
    {
        return BUY_TYPE_CONSTANT;
    }
    else
    {
        return SELL_TYPE_CONSTANT;
    }
}

int GetGridNoByComment(string comment)
{
    return (int)StringToInteger(comment);
}

ulong GetMagicNo()
{
    string magicNoStr = IntegerToString(magic1Global) + "0" + IntegerToString(magic2Input) + "0";
    return StringToInteger(magicNoStr);
}

int GetTotalPosition()
{
    int result = 0;
    int totalPosition = PositionsTotal();
    for (int i = 0; i < totalPosition; i++)
    {
        ulong positionTicket = PositionGetTicket(i);
        if (PositionGetInteger(POSITION_MAGIC) == magicNoGlobal)
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

int GetTotalOrder()
{
    int result = 0;
    for (int i = 0; i < OrdersTotal(); i++)
    {
        ulong ticket = OrderGetTicket(i);
        if (OrderGetInteger(ORDER_MAGIC) == magicNoGlobal)
        {
            result++;
        }
    }
    return result;
}
