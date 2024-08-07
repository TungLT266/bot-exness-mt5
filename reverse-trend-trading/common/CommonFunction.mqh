#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

extern double gridAmountInput;
extern ulong magicNumberInput;

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

int GetGridNoBuyUp()
{
   for (int i = gridNoCurrentGlobal + 1; i < gridNoCurrentGlobal + 11; i++)
   {
      if (!IsExistGridNoInPosition(i, BUY_TYPE_CONSTANT))
      {
         return i;
      }
   }
   return 0;
}

int GetGridNoSellUp()
{
   for (int i = gridNoCurrentGlobal + 1; i < gridNoCurrentGlobal + 11; i++)
   {
      if (!IsExistGridNoInPosition(i, SELL_TYPE_CONSTANT))
      {
         return i;
      }
   }
   return 0;
}

int GetGridNoBuyDown()
{
   for (int i = gridNoCurrentGlobal; i > gridNoCurrentGlobal - 10; i--)
   {
      if (!IsExistGridNoInPosition(i, BUY_TYPE_CONSTANT))
      {
         return i;
      }
   }
   return 0;
}

int GetGridNoSellDown()
{
   for (int i = gridNoCurrentGlobal; i > gridNoCurrentGlobal - 10; i--)
   {
      if (!IsExistGridNoInPosition(i, SELL_TYPE_CONSTANT))
      {
         return i;
      }
   }
   return 0;
}

bool IsExistGridNoInPosition(int gridNo, string typeStr)
{
   int totalPosition = PositionsTotal();
   for (int i = 0; i < totalPosition; i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if (magic == magicNumberInput)
      {
         string comment = PositionGetString(POSITION_COMMENT);
         ENUM_POSITION_TYPE positionType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         if (typeStr == GetTypePositionStrByType(positionType) && gridNo == StringToInteger(comment))
         {
            return true;
         }
      }
   }
   return false;
}