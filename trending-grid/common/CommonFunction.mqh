#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

extern int magic2Input;
extern double gridAmountInput;
extern double slGridAmountInput;
extern int totalGridInput;

extern int magic1Global;
extern ulong magicNoGlobal;
extern double priceStartGridGlobal;

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;
extern string UNKNOWN_CONSTANT;

double GetPriceByGridNo(int gridNo)
{
    return priceStartGridGlobal + ((gridNo - 1) * gridAmountInput);
}

string GetPositionTypeStr(ENUM_POSITION_TYPE type)
{
    if (type == POSITION_TYPE_BUY)
    {
        return BUY_TYPE_CONSTANT;
    }
    else if (type == POSITION_TYPE_SELL)
    {
        return SELL_TYPE_CONSTANT;
    }
    return UNKNOWN_CONSTANT;
}

string GetOrderTypeStr(ENUM_ORDER_TYPE type)
{
    if (type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_BUY_STOP)
    {
        return BUY_TYPE_CONSTANT;
    }
    else if (type == ORDER_TYPE_SELL_LIMIT || type == ORDER_TYPE_SELL_STOP)
    {
        return SELL_TYPE_CONSTANT;
    }
    return UNKNOWN_CONSTANT;
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
    long value1Long = (long)MathRound(value1 * 100000);
    long value2Long = (long)MathRound(value2 * 100000);

    if (value1Long > value2Long)
    {
        return 1;
    }
    else if (value1Long < value2Long)
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

double GetPriceMinGrid(double price)
{
    return price - (gridAmountInput / 2);
}

double GetPriceMaxGrid(double price)
{
    return price + (gridAmountInput / 2);
}

double GetSLUp()
{
    return priceStartGridGlobal + (gridAmountInput * (totalGridInput - 1)) + slGridAmountInput;
}

double GetSLDown()
{
    return priceStartGridGlobal - slGridAmountInput;
}
