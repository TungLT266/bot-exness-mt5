#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

extern double gridAmountInput;
extern int gridTotalInput;
extern ulong magicNumberInput;

extern double numberStartGridGlobal;
extern double priceStartGridGlobal;
extern int differenceBuyAndSellGlobal;

double GetPriceByGridNumber(double gridNo)
{
   return priceStartGridGlobal + ((gridNo - 1) * gridAmountInput);
}

double GetNumberStartGrid(double price)
{
   return MathFloor(price / gridAmountInput) + 1 - (gridTotalInput / 2);
}

string GetCommentByGridNo(double gridNo, ENUM_ORDER_TYPE type)
{
   string prefix = "";
   if (type == ORDER_TYPE_BUY_STOP)
   {
      prefix = "BT";
   }
   else if (type == ORDER_TYPE_SELL_LIMIT)
   {
      prefix = "SL";
   }
   else if (type == ORDER_TYPE_SELL_STOP)
   {
      prefix = "ST";
   }
   else
   {
      prefix = "BL";
   }

   string str = StringFormat("%.0f", (gridNo + numberStartGridGlobal));
   if (StringLen(str) >= 4)
   {
      return prefix + "." + StringSubstr(str, StringLen(str) - 3) + "." + StringSubstr(str, 0, StringLen(str) - 3) + ".No." + StringFormat("%.0f", gridNo);
   }
   return prefix + "." + str + ".No." + StringFormat("%.0f", gridNo);
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
