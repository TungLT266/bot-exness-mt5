#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

extern double gridAmountInput;
extern ulong magicNumberInput;
extern int totalOrderInput;

extern int gridNoCurrentGlobal;
extern int differenceBuyAndSellGlobal;

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;

double GetPriceByGridNo(int gridNo)
{
   return gridNo * gridAmountInput;
}

int GetGridNoByPrice(double price)
{
   return (int)MathFloor(price / gridAmountInput);
}

int GetTotalPosition()
{
   int result = 0;
   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if (magic == magicNumberInput)
      {
         result++;
      }
   }
   return result;
}

int GetTotalPositionBuy()
{
   int result = 0;
   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if (magic == magicNumberInput)
      {
         ENUM_POSITION_TYPE positionType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         if (positionType == POSITION_TYPE_BUY)
         {
            result++;
         }
      }
   }
   return result;
}

int GetTotalPositionSell()
{
   int result = 0;
   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if (magic == magicNumberInput)
      {
         ENUM_POSITION_TYPE positionType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         if (positionType == POSITION_TYPE_SELL)
         {
            result++;
         }
      }
   }
   return result;
}

string GetTypeOrderStrByType(ENUM_ORDER_TYPE type)
{
   if (type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_BUY_STOP)
   {
      return BUY_TYPE_CONSTANT;
   }
   else if (type == ORDER_TYPE_SELL_LIMIT || type == ORDER_TYPE_SELL_STOP)
   {
      return SELL_TYPE_CONSTANT;
   }
   return "";
}

string GetTypePositionStrByType(ENUM_POSITION_TYPE type)
{
   if (type == POSITION_TYPE_BUY)
   {
      return BUY_TYPE_CONSTANT;
   }
   else if (type == POSITION_TYPE_SELL)
   {
      return SELL_TYPE_CONSTANT;
   }
   return "";
}

string GetTypeOrderByGridNo(int gridNo)
{
   if (gridNo > gridNoCurrentGlobal)
   {
      int start = gridNoCurrentGlobal + 1;
      int end = gridNoCurrentGlobal + differenceBuyAndSellGlobal;
      if (gridNo >= start && gridNo <= end)
      {
         return SELL_TYPE_CONSTANT;
      }
      else
      {
         return BUY_TYPE_CONSTANT;
      }
   }
   else
   {
      int start = gridNoCurrentGlobal + differenceBuyAndSellGlobal + 1;
      int end = gridNoCurrentGlobal;
      if (gridNo >= start && gridNo <= end)
      {
         return BUY_TYPE_CONSTANT;
      }
      else
      {
         return SELL_TYPE_CONSTANT;
      }
   }
}
