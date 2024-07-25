#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

extern ulong magicGlobal;

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
        if (OrderGetInteger(ORDER_MAGIC) == magicGlobal)
        {
            result++;
        }
    }
    return result;
}

int GetTotalPosition()
{
    int result = 0;
    int totalPosition = PositionsTotal();
    for (int i = 0; i < totalPosition; i++)
    {
        ulong positionTicket = PositionGetTicket(i);
        if (PositionGetInteger(POSITION_MAGIC) == magicGlobal)
        {
            result++;
        }
    }
    return result;
}
