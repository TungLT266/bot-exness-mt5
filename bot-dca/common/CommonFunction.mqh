#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/MagicDetailObject.mqh>

extern int magic2Input;
extern int tpNumberFirstInput;
extern int tpNumberInput;

extern int magic1Global;

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

int GetTotalPositionByMagicNo(ulong magicNo)
{
    int result = 0;
    for (int i = 0; i < PositionsTotal(); i++)
    {
        ulong positionTicket = PositionGetTicket(i);
        if (PositionGetInteger(POSITION_MAGIC) == magicNo)
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

int GetTotalOrderByMagicNo(ulong magicNo)
{
    int result = 0;
    for (int i = 0; i < OrdersTotal(); i++)
    {
        ulong ticket = OrderGetTicket(i);
        if (OrderGetInteger(ORDER_MAGIC) == magicNo)
        {
            result++;
        }
    }
    return result;
}

double GetSLByMagicDetail(MagicDetailObject &magicDetail)
{
    if (magicDetail.takeProfitStart == BUY_TYPE_CONSTANT && magicDetail.takeProfitCurrent == BUY_TYPE_CONSTANT)
    {
        return magicDetail.priceStart - magicDetail.slAmount;
    }
    else if (magicDetail.takeProfitStart == SELL_TYPE_CONSTANT && magicDetail.takeProfitCurrent == SELL_TYPE_CONSTANT)
    {
        return magicDetail.priceStart + magicDetail.slAmount;
    }
    return magicDetail.priceStart;
}

double GetTPByMagicDetail(MagicDetailObject &magicDetail)
{
    if (magicDetail.takeProfitStart == BUY_TYPE_CONSTANT)
    {
        if (magicDetail.totalPosition == 1)
        {
            return magicDetail.priceStart + (magicDetail.slAmount * tpNumberFirstInput);
        }
        else if (magicDetail.takeProfitCurrent == BUY_TYPE_CONSTANT)
        {
            return magicDetail.priceStart + (magicDetail.slAmount * tpNumberInput);
        }
        return magicDetail.priceStart - (magicDetail.slAmount * (tpNumberInput + 1));
    }
    else
    {
        if (magicDetail.totalPosition == 1)
        {
            return magicDetail.priceStart - (magicDetail.slAmount * tpNumberFirstInput);
        }
        else if (magicDetail.takeProfitCurrent == SELL_TYPE_CONSTANT)
        {
            return magicDetail.priceStart - (magicDetail.slAmount * tpNumberInput);
        }
        return magicDetail.priceStart + (magicDetail.slAmount * (tpNumberInput + 1));
    }
}
