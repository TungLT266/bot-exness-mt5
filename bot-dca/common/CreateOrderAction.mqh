#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"

#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/CommonFunction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/53785E099C927DB68A545C249CDBCE06/MQL5/Experts/bot-ea/bot-dca/common/MagicDetailObject.mqh>

extern double volumeInput;
extern int limitGridInput;
extern int totalMagicInput;
extern bool isTradeBuyFirstInput;

extern MagicDetailObject magicDetailArrGlobal[];

extern string BUY_TYPE_CONSTANT;
extern string SELL_TYPE_CONSTANT;

void CreateOrderAction()
{
   if (ArraySize(magicDetailArrGlobal) < totalMagicInput)
   {
      CreateOrderFirst();
      return;
   }
   CreateOrderAfterFirst();
}

void CreateOrderAfterFirst()
{
   for (int i = 0; i < ArraySize(magicDetailArrGlobal); i++)
   {
      MagicDetailObject magicDetail = magicDetailArrGlobal[i];
      if (magicDetail.totalPosition > 0 && magicDetail.totalPosition < limitGridInput)
      {
         if (GetTotalOrderByMagicNo(magicDetail.magicNo) == 0)
         {
            CreateOrder(magicDetail.totalPosition + 1, magicDetail);
         }
      }
   }
}

int GetMagic3OrderFirst()
{
   if (ArraySize(magicDetailArrGlobal) == 0)
   {
      return 1;
   }
   for (int i = 1; i <= 9; i++)
   {
      if (!IsExitsMagicDetailByMagicNo(magicDetailArrGlobal, GetMagicNumber(i)))
      {
         return i;
      }
   }
   return 0;
}

void CreateOrderFirst()
{
   int magic3 = GetMagic3OrderFirst();
   if (magic3 == 0)
   {
      Print("Total magic is limit.");
      return;
   }
   ENUM_ORDER_TYPE orderType;
   if (isTradeBuyFirstInput)
   {
      orderType = ORDER_TYPE_BUY;
   }
   else
   {
      orderType = ORDER_TYPE_SELL;
   }

   ulong magic = GetMagicNumber(magic3);

   MqlTradeRequest request;
   MqlTradeResult result;

   ZeroMemory(request);
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = volumeInput;
   request.type = orderType;
   request.comment = "1";
   request.magic = magic;

   if (OrderSend(request, result))
   {
      Print("Create order success: Type: ", EnumToString(orderType), " - Ticket: ", result.order, " - No: 1 - Magic: ", magic);
   }
   else
   {
      Print("Create order failure: Type: ", EnumToString(orderType), " - Comment: ", result.comment, " - No: 1 - Magic: ", magic);
   }
}

void CreateOrder(int gridNo, MagicDetailObject &magicDetail)
{
   ENUM_ORDER_TYPE orderType = GetTypeOrderByMagic3(magicDetail.takeProfitCurrent);

   MqlTradeRequest request;
   MqlTradeResult result;

   ZeroMemory(request);
   request.action = TRADE_ACTION_PENDING;
   request.symbol = _Symbol;
   request.volume = GetVolumeOrderByMagicNo(magicDetail.magicNo);
   request.type = orderType;
   request.price = GetSLByMagicDetail(magicDetail);
   request.comment = IntegerToString(gridNo);
   request.magic = magicDetail.magicNo;

   if (OrderSend(request, result))
   {
      Print("Create order success: Type: ", EnumToString(orderType), " - Ticket: ", result.order, " - No: ", gridNo, " - Magic: ", magicDetail.magicNo);
   }
   else
   {
      Print("Create order failure: Type: ", EnumToString(orderType), " - Comment: ", result.comment, " - No: ", gridNo, " - Magic: ", magicDetail.magicNo);
   }
}

ENUM_ORDER_TYPE GetTypeOrderByMagic3(string takeProfitCurrent)
{
   if (takeProfitCurrent == BUY_TYPE_CONSTANT)
   {
      return ORDER_TYPE_SELL_STOP;
   }
   else
   {
      return ORDER_TYPE_BUY_STOP;
   }
}

double GetVolumeOrderByMagicNo(ulong magicNo)
{
   double totalVolumeBuy = 0;
   double totalVolumeSell = 0;

   for (int i = 0; i < PositionsTotal(); i++)
   {
      ulong positionTicket = PositionGetTicket(i);
      if (PositionGetInteger(POSITION_MAGIC) == magicNo)
      {
         ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         if (type == POSITION_TYPE_BUY)
         {
            totalVolumeBuy += PositionGetDouble(POSITION_VOLUME);
         }
         else
         {
            totalVolumeSell += PositionGetDouble(POSITION_VOLUME);
         }
      }
   }

   if (CompareDouble(totalVolumeBuy, totalVolumeSell) > 0)
   {
      return totalVolumeBuy * 2 - totalVolumeSell;
   }
   else
   {
      return totalVolumeSell * 2 - totalVolumeBuy;
   }
}
