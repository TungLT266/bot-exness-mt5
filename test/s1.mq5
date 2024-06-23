//+------------------------------------------------------------------+
//|                                                           s1.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>

CTrade trade;

// Variable
double volumeInput = 0.01;
double stopPriceRateInput = 0.01;
double stopPriceSLRateInput = 0.01;
double stopPriceTPRateInput = 0.1;

double buyStopPrice;
double buyStopPriceSL;
double buyStopPriceTP;

double sellStopPrice;
double sellStopPriceSL;
double sellStopPriceTP;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   Print("Giá mua: ", bidPrice, " - Giá bán: ", askPrice);
   
   Print("Rate stop: ", stopPriceRateInput, " - Rate SL: ", stopPriceSLRateInput, " - Rate TP: ", stopPriceTPRateInput);
   
   
   //double price = iClose(Symbol(), PERIOD_CURRENT, 0);
   
   buyStopAction(askPrice);
   sellStopAction(bidPrice);
   
   
   Print("EA đã được khởi tạo");
//---
   return(INIT_SUCCEEDED);
  }
  
  
void buyStopAction(double askPrice)
{
   buyStopPrice = askPrice + askPrice * (stopPriceRateInput / 100);
   buyStopPriceSL = buyStopPrice - buyStopPrice * (stopPriceSLRateInput / 100);
   buyStopPriceTP = buyStopPrice + buyStopPrice * (stopPriceTPRateInput / 100);
   
   MqlTradeRequest request;
   MqlTradeResult result;

   request.action = TRADE_ACTION_PENDING;
   request.symbol = _Symbol;
   request.volume = volumeInput; 
   request.type = ORDER_TYPE_BUY_STOP;
   request.price = buyStopPrice; 
   request.sl = buyStopPriceSL; 
   request.tp = buyStopPriceTP;
   
   if (OrderSend(request, result))
   {
       Print("Buy Top; Price: ", buyStopPrice, " - SL: ", buyStopPriceSL, " - TP: ", buyStopPriceTP, " - Volume: ", volumeInput);
   }
   else
   {
       Print("Buy Top Error: ", result.comment);
   }
}

void sellStopAction(double bidPrice)
{
   sellStopPrice = bidPrice - bidPrice * (stopPriceRateInput / 100);
   sellStopPriceSL = sellStopPrice + sellStopPrice * (stopPriceSLRateInput / 100);
   sellStopPriceTP = sellStopPrice - sellStopPrice * (stopPriceTPRateInput / 100);
   
   MqlTradeRequest request;
   MqlTradeResult result;

   request.action = TRADE_ACTION_PENDING;
   request.symbol = _Symbol;
   request.volume = volumeInput; 
   request.type = ORDER_TYPE_SELL_STOP;
   request.price = sellStopPrice; 
   request.sl = sellStopPriceSL; 
   request.tp = sellStopPriceTP;
   
   if (OrderSend(request, result))
   {
       Print("Sell Top; Price: ", sellStopPrice, " - SL: ", sellStopPriceSL, " - TP: ", sellStopPriceTP, " - Volume: ", volumeInput);
   }
   else
   {
       Print("Sell Top Error: ", result.comment);
   }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Print("EA đã bị gỡ bỏ, lý do: ", reason);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---


   
  }
//+------------------------------------------------------------------+
