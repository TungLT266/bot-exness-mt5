#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/BB16F565FAAA6B23A20C26C49416FF05/MQL5/Experts/bot-xm-mt5/trend-trading-v3/common/CreateValueGlobal.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/BB16F565FAAA6B23A20C26C49416FF05/MQL5/Experts/bot-xm-mt5/trend-trading-v3/common/CommonFunction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/BB16F565FAAA6B23A20C26C49416FF05/MQL5/Experts/bot-xm-mt5/trend-trading-v3/common/CreateOrderAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/BB16F565FAAA6B23A20C26C49416FF05/MQL5/Experts/bot-xm-mt5/trend-trading-v3/common/RemoveOrderAction.mqh>
#include <C:/Users/admin/AppData/Roaming/MetaQuotes/Terminal/BB16F565FAAA6B23A20C26C49416FF05/MQL5/Experts/bot-xm-mt5/trend-trading-v3/common/ModifyPositionTPAction.mqh>

// Input
int gridPointAmountInput = 3000;
double volumeInput = 0.01;
ulong magicNumberInput = 666663;

// Global
int gridAtPriceCurrentGlobal = 0;
int differenceBuyAndSellPositionGlobal = 0; // Nếu value > 0 => Buy > Sell

int orderGridNoUpGlobal = 0;
int orderGridNoDownGlobal = 0;
ENUM_ORDER_TYPE orderTypeUpGlobal = ORDER_TYPE_SELL_LIMIT;
ENUM_ORDER_TYPE orderTypeDownGlobal = ORDER_TYPE_BUY_LIMIT;

double tpBuyGlobal = 0;
double tpSellGlobal = 0;

int DELAY_SECOND = 3;

int OnInit()
{
   Print("Start bot");

   MainFuction();

   EventSetTimer(DELAY_SECOND);

   return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   Print("EA đã bị gỡ bỏ, lý do: ", reason);
}

void OnTimer()
{
   MainFuction();
}

void MainFuction()
{
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   int gridAtPriceCurrentNew = (int)MathFloor(bidPrice / (gridPointAmountInput * _Point));
   if (gridAtPriceCurrentNew != (int)MathFloor(askPrice / (gridPointAmountInput * _Point)))
   {
      return;
   }

   gridAtPriceCurrentGlobal = gridAtPriceCurrentNew;

   RefreshGlobalVariable();
   ModifyPositionTPAction();

   RefreshGlobalVariable();
   RemoveOrderAction();
   CreateOrderAction();
}

void RefreshGlobalVariable()
{
   differenceBuyAndSellPositionGlobal = GetDifferenceBuyAndSellPosition();

   int orderGridNoUpNew = GetOrderGridNoUp();
   ENUM_ORDER_TYPE orderTypeUpNew = GetOrderTypeUp();
   if (orderGridNoUpGlobal != orderGridNoUpNew || orderTypeUpGlobal != orderTypeUpNew)
   {
      orderGridNoUpGlobal = orderGridNoUpNew;
      orderTypeUpGlobal = orderTypeUpNew;
      Print("Order Up: Grid No: ", orderGridNoUpGlobal, " - Type: ", EnumToString(orderTypeUpGlobal));
   }

   int orderGridNoDownNew = GetOrderGridNoDown();
   ENUM_ORDER_TYPE orderTypeDownNew = GetOrderTypeDown();
   if (orderGridNoDownGlobal != orderGridNoDownNew || orderTypeDownGlobal != orderTypeDownNew)
   {
      orderGridNoDownGlobal = orderGridNoDownNew;
      orderTypeDownGlobal = orderTypeDownNew;
      Print("Order Down: Grid No: ", orderGridNoDownGlobal, " - Type: ", EnumToString(orderTypeDownGlobal));
   }
}

void OnTick() {}
