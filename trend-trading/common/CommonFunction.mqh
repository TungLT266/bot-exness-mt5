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

int GetGridNoStart()
{
   return gridNoCurrentGlobal - (totalOrderInput / 2) + 1;
}

int GetGridNoEnd()
{
   return gridNoCurrentGlobal + (totalOrderInput / 2);
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

string GetTypeOrderByGridNo(int gridNo)
{
   int halfTotalOrder = totalOrderInput / 2;
   int numberOrderBuyTop = halfTotalOrder;
   int numberOrderSellTop = halfTotalOrder;
   int numberOrderBuyLimit = 0;
   int numberOrderSellLimit = 0;

   if (differenceBuyAndSellGlobal > 0)
   {
      if (differenceBuyAndSellGlobal >= halfTotalOrder)
      {
         numberOrderSellLimit = halfTotalOrder;
         numberOrderBuyTop = 0;
      }
      else
      {
         numberOrderSellLimit = differenceBuyAndSellGlobal;
         numberOrderBuyTop = halfTotalOrder - differenceBuyAndSellGlobal;
      }
   }
   else if (differenceBuyAndSellGlobal < 0)
   {
      if (MathAbs(differenceBuyAndSellGlobal) >= halfTotalOrder)
      {
         numberOrderBuyLimit = halfTotalOrder;
         numberOrderSellTop = 0;
      }
      else
      {
         numberOrderBuyLimit = MathAbs(differenceBuyAndSellGlobal);
         numberOrderSellTop = halfTotalOrder - MathAbs(differenceBuyAndSellGlobal);
      }
   }

   if (numberOrderBuyTop > 0)
   {
      int start = gridNoCurrentGlobal + numberOrderSellLimit + 1;
      int end = gridNoCurrentGlobal + numberOrderSellLimit + numberOrderBuyTop;
      if (gridNo >= start && gridNo <= end)
      {
         return BUY_TYPE_CONSTANT;
      }
   }
   if (numberOrderSellLimit > 0)
   {
      int start = gridNoCurrentGlobal + 1;
      int end = gridNoCurrentGlobal + numberOrderSellLimit;
      if (gridNo >= start && gridNo <= end)
      {
         return SELL_TYPE_CONSTANT;
      }
   }
   if (numberOrderBuyLimit > 0)
   {
      int start = gridNoCurrentGlobal - numberOrderBuyLimit + 1;
      int end = gridNoCurrentGlobal;
      if (gridNo >= start && gridNo <= end)
      {
         return BUY_TYPE_CONSTANT;
      }
   }
   if (numberOrderSellTop > 0)
   {
      int start = gridNoCurrentGlobal - numberOrderBuyLimit - numberOrderSellTop + 1;
      int end = gridNoCurrentGlobal - numberOrderBuyLimit;
      if (gridNo >= start && gridNo <= end)
      {
         return SELL_TYPE_CONSTANT;
      }
   }
   return "";
}
