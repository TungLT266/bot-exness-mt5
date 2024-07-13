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

string GetTypeOrderByGridNo(int gridNo)
{
   int numberOrderBuyTop = totalOrderInput / 2;
   int numberOrderSellTop = totalOrderInput / 2;
   int numberOrderBuyLimit = 0;
   int numberOrderSellLimit = 0;

   if (differenceBuyAndSellGlobal > 0)
   {
      numberOrderSellLimit = differenceBuyAndSellGlobal;
      if (numberOrderSellLimit > (totalOrderInput / 2))
      {
         numberOrderSellLimit = totalOrderInput / 2;
      }
      numberOrderBuyTop = (totalOrderInput / 2) - differenceBuyAndSellGlobal;
   }
   else if (differenceBuyAndSellGlobal < 0)
   {
      numberOrderBuyLimit = differenceBuyAndSellGlobal * (-1);
      if (numberOrderBuyLimit > (totalOrderInput / 2))
      {
         numberOrderBuyLimit = totalOrderInput / 2;
      }
      numberOrderSellTop = (totalOrderInput / 2) + differenceBuyAndSellGlobal;
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
